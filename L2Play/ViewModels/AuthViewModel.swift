//
//  Provider.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseCore
import GoogleSignIn
import Combine

@MainActor
class AuthViewModel: ObservableObject, AsyncOperationHandler {
    private var ref: DatabaseReference!
    private let manager = FirebaseManager()
    private let guest = User.dummy()
    
    @Published var isAuthenticated: Bool = false
    @Published var user: User
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init(isAuthenticated: Bool, user: User) {
        self.isAuthenticated = isAuthenticated
        self.user = user
        self.ref = Database.database().reference()
    }
    
    init() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.user = user
            self.isAuthenticated = true
            
            self.ref = Database.database().reference()
        } else {
            self.user = guest
            self.isAuthenticated = false
        }
    }
    
    var currentUserUUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private func setInCtx() {
        if let userData = try? JSONEncoder().encode(self.user) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
    }
    
    func refreshUser(_ user: User) async {
        let result: Result<User, Error>  = await performAsyncOperation {
            try await self.manager.read(collection: .users, id: user.id)
        }
        
        switch result {
        case .success(let fetchedUser):
            self.user = fetchedUser
            self.setInCtx()
        case .failure(let error):
            print(error.localizedDescription)
            self.errorMessage = "Failed to refresh user: \(error.localizedDescription)"
        }
    }
    
    func deleteAccount(email: String) async {
        self.isLoading = true
        
        if !AuthValidator.compare(providedEmail: email, currentEmail: user.email) {
            self.isLoading = false
            self.errorMessage = "Entered email is not the same as your current email."
            return
        }
        
        let _ = await performAsyncOperation {
            return try await self.deleteAccountFromFirebase(email: email)
        }
    }
    
    private func deleteAccountFromFirebase(email: String) async throws {
        if let firebaseUser = Auth.auth().currentUser {
            try await firebaseUser.delete()
            self.manager.delete(collection: .users, id: email)
            self.user = User.dummy()
            self.isAuthenticated = false
            UserDefaults.standard.removeObject(forKey: "currentUser")
        } else {
            throw NSError(domain: "AuthViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
    }
    
    func login(email: String, password: String) {
        self.isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let err = error {
                self.handleAuthError(message: "Failed to authenticate user.", error: err)
                return
            }
            
            guard let user = result?.user else {
                self.handleAuthError(message: "User not found.")
                return
            }
            
            let u = User(firebaseUser: user)
            self.handleUser(user: u)
        }
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) {
        self.isLoading = true
        let av = AuthValidator(firstName: firstName, lastName: lastName, email: email, password: password)
        
        guard av.validateSignUp() else {
            self.handleAuthError(message: "Email or password are incorrect", error: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let fu = authResult?.user, error == nil {
                let u = User(id: fu.uid, firstName: firstName, lastName: lastName, email: email)
                self.handleUser(user: u)
            } else {
                self.handleAuthError(message: "Failed to handle user", error: error)
            }
        }
    }
    
    func continueWithGoogle(presenting viewController: UIViewController) {
        self.isLoading = true
        
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "Failed to retrieve client ID."
            self.isLoading = false
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleAuthError(message: "Google sign-in failed.", error: error)
                self.isLoading = false
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                self.handleAuthError(message: "Failed to retrieve Google token.")
                self.isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.handleAuthError(message: "Firebase authentication failed.", error: error)
                    self.isLoading = false
                    return
                }
                
                guard let firebaseUser = result?.user else {
                    self.handleAuthError(message: "Failed to authenticate user.")
                    self.isLoading = false
                    return
                }
                
                self.handleUser(user: User(firebaseUser: firebaseUser))
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    
    private func handleAuthError(message: String, error: Error? = nil) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = message
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleUser(user: User) {
        Task {
            let result: Result<User, Error> = await performAsyncOperation {
                try await self.manager.read(collection: .users, id: user.id)
            }
            
            switch result {
            case .success(let existingUser):
                DispatchQueue.main.async {
                    self.user = existingUser
                    self.isAuthenticated = true
                    self.setInCtx()
                }
            case .failure:
                let r : Result<User, Error> = await performAsyncOperation {
                    try await self.manager.create(collection: .users, object: user, customID: user.id)
                }
                
                switch r {
                case .failure(let err):
                    self.handleAuthError(message: "Error creating user: \(err.localizedDescription)")
                case .success(let user):
                    DispatchQueue.main.async {
                        self.user = user
                        self.isAuthenticated = true
                        self.setInCtx()
                    }
                }
            }
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.isAuthenticated = false
            self.user = guest
            UserDefaults.standard.removeObject(forKey: "currentUser")
        } catch let signOutError as NSError {
            self.errorMessage = signOutError.localizedDescription
        }
    }
    
    func followUser(_ otherUser: User) async {
        let r: Result<_, Error> = await performAsyncOperation {
            try await self.updateFollowStatus(for: otherUser)
        }
        
        switch r {
        case .success:
            self.setInCtx()
        case .failure:
            break
        }
    }
    
    private func updateFollowStatus(for otherUser: User) async throws {
        var copy = otherUser
        self.user.toggleFollowStatus(&copy)
        
        try await self.manager.update(collection: .users, id: copy.id, object: copy)
        try await self.manager.update(collection: .users, id: self.user.id, object: self.user)
    }
    
    func toogleBlockUser(_ otherUser: inout User) async {
        var copy = otherUser
        
        // we have blocked so update other user state
        if self.user.block(who: &copy) {
            let _: Result<_, Error> = await performAsyncOperation {
                try await self.manager.update(collection: .users, id: copy.id, object: copy)
            }
        }
        
        let result: Result<_, Error> = await performAsyncOperation {
            try await self.manager.update(collection: .users, id: self.user.id, object: self.user)
        }
        
        switch result {
        case .success:
            self.setInCtx()
            break
        case .failure:
            break
        }
    }
}
