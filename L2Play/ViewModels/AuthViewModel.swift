//
//  Provider.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseCore
import GoogleSignIn
import Combine


class AuthViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let firebaseManager = FirebaseManager()
    private let guest = User.dummy()
    
    @Published var isAuthenticated: Bool = false
    @Published var user: User
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false	
    
    
    init(isAuthenticated: Bool, user: User) {
        self.isAuthenticated = isAuthenticated
        self.user = user
    }
     
     init() {
         if let userData = UserDefaults.standard.data(forKey: "currentUser"),
            let user = try? JSONDecoder().decode(User.self, from: userData) {
             self.user = user
             self.isAuthenticated = true
         } else {
             self.user = guest
             self.isAuthenticated = false
         }
     }
    
    private func setInCtx() {
        if let userData = try? JSONEncoder().encode(self.user) {
               UserDefaults.standard.set(userData, forKey: "currentUser")
           }
    }
    
    func refreshUser(_ user: User) async {
        do {
            let fetchedUser: User = try await firebaseManager.read(collection: "users", id: user.email)
            
            DispatchQueue.main.async {
                self.user = fetchedUser
                self.setInCtx()
            }
        } catch let err {
            print("Failed to refresh user: \(err.localizedDescription)")
             self.errorMessage = "Failed to refresh user."
        }
    }
    
    
    func deleteAccount(email: String) {
        self.isLoading = true
        
        // validate email (is it event possible that user can't have email on google ?)
        if !AuthValidator.compare(providedEmail: email, currentEmail: user.email) {
            self.isLoading = false
            self.errorMessage = "Entered email is not the same as your current email."
            return
        }
        
        
        // remove from ctx
        if let fuser = Auth.auth().currentUser {
            fuser.delete() { error in
                if let _ = error {
                    self.errorMessage = "Failed to remove account."
                    self.isLoading = false
                } else {
                    // remove from db
                    self.firebaseManager.delete(collection: "users", id: email) { result in
                        switch result {
                        case .failure:
                            self.errorMessage = "Failed to remove user."
                        case .success:
                            self.user = User.dummy()
                            self.isAuthenticated = false
                            UserDefaults.standard.removeObject(forKey: "currentUser")
                        }
                        
                    }
                    
                    self.isLoading = false
                }
            }
        }
    }
    
    
    func login(email: String, password: String) {
        self.isLoading = true
        self.firebaseManager.signIn(email: email, password: password) { result in
            switch result {
            case .failure(let err):
                self.errorMessage = "Failed to auth user: \(err.localizedDescription)"
            case .success:
                let tmpUser = Auth.auth().currentUser!
                self.firebaseManager.getOrCreateUser(user: tmpUser, onlyGet: true) { result in
                    switch result {
                    case .failure(let err):
                        self.errorMessage = "Failed to get user: \(err.localizedDescription)"
                    case .success(let user):
                        self.user = user
                        self.isAuthenticated = true
                        self.isLoading = false
                        self.setInCtx()
                    }
                }
            }
        }
    }
    
    
    func signUp(email: String, password: String, firstName: String, lastName: String) {
        self.isLoading = true

        // validate email and password
        if !AuthValidator.validate(email: email) {
            self.errorMessage = "Not an email"
            self.isLoading = false
            return
        }
        
        if !AuthValidator.validate(password: password) {
            self.errorMessage = "Password is too weak"
            self.isLoading = false
            return
        }
        
        if !AuthValidator.validate(names: firstName, lastName) {
            self.errorMessage = "Too long or empty name"
            self.isLoading = false
            return
        }
        
        
        self.firebaseManager.createUser(email: email, password: password){ res in
            switch res {
            case .failure(let err):
                self.errorMessage = err.localizedDescription
            case .success:
                guard let tmpUser = Auth.auth().currentUser else {
                    self.errorMessage = "Failed to retrieve user from Firebase Auth"
                    self.isLoading = false
                    return
                }
                
                tmpUser.displayName = firstName + " " + lastName
                
                // create user
                self.firebaseManager.getOrCreateUser(user: tmpUser) { result in
                    switch result {
                    case .failure(let err):
                        self.errorMessage = err.localizedDescription
                    case .success(let user):
                        self.isLoading = false
                        self.user = user
                        self.isAuthenticated = true
                        self.setInCtx()
                    }
                    
                }
            }
            
        }
    }
    
    func continueWithGoogle(presenting viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        self.isLoading = true
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else {
                self.errorMessage = error!.localizedDescription
                self.isLoading = false
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.errorMessage = "Failed to get token"
                self.isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            self.firebaseManager.signIn(credential: credential) { result in
                switch result {
                case .success:
                    guard let tmpUser = Auth.auth().currentUser else {
                        self.errorMessage = "Failed to retrieve user from Firebase Auth"
                        self.isLoading = false
                        return
                    }
                    
                    self.firebaseManager.getOrCreateUser(user: tmpUser) { result in
                        switch result {
                        case .failure(let error):
                            self.errorMessage = "Failed to auth user: \(error.localizedDescription)"
                            
                        case .success(let user):
                            self.user = user
                            self.isAuthenticated = true
                            self.setInCtx()
                        }
                        
                        self.isLoading = false
                    }
                    
                case .failure(let error):
                    self.errorMessage = "Failed to sign in: \(error.localizedDescription)"
                    self.isLoading = false
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
}

