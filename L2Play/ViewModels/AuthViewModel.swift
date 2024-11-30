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
    @Published var chats: [Chat] = []
    
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
            try await self.manager.read(collection: .users, id: user.email)
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
            
            if let _ = authResult?.user, error == nil {
                let u = User(firstName: firstName, lastName: lastName, email: email)
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
                try await self.manager.read(collection: .users, id: user.email)
            }
            
            switch result {
            case .success(let existingUser):
                DispatchQueue.main.async {
                    self.user = existingUser
                    self.isAuthenticated = true
                    self.setInCtx()
                }
            case .failure(let error):
                self.handleAuthError(message: "Failed to create user in database.", error: error)
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
    
    func followUser(_ u: User) async {
        let result = await performAsyncOperation {
            try await self.updateFollowStatus(for: u)
        }
        
        switch result {
        case .success:
            break
        case .failure(let error):
            self.errorMessage = "Failed to follow: \(error.localizedDescription)"
        }
    }
    
    private func updateFollowStatus(for u: User) async throws {
        var otherUser: User = try await self.manager.read(collection: .users, id: u.email)
        
        if otherUser.following.contains(user.id) {
            otherUser.following.removeAll(where: { $0 == user.id })
            user.followers.removeAll(where: { $0 == otherUser.id })
        } else {
            otherUser.following.append(user.id)
            user.followers.append(otherUser.id)
        }
        
        try await self.manager.update(collection: .users, id: otherUser.email, object: otherUser)
        try await self.manager.update(collection: .users, id: user.email, object: user)
    }
    
    func listUserChats() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }
        
        self.isLoading = true
        ref.child("chats").observeSingleEvent(of: .value) { [weak self] (snapshot: DataSnapshot) in
            var fetchedChats: [Chat] = []
            
            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let participants = childSnapshot.childSnapshot(forPath: "participants").value as? [String: Bool],
                   participants[currentUser.uid] == true {
                    let messagesSnapshot = childSnapshot.childSnapshot(forPath: "messages")
                    let messages: [Message] = messagesSnapshot.children.compactMap { messageChild in
                        guard let messageSnapshot = messageChild as? DataSnapshot,
                              let messageData = messageSnapshot.value as? [String: Any],
                              let text = messageData["text"] as? String,
                              let senderId = messageData["senderId"] as? String,
                              let timestamp = messageData["timestamp"] as? Double else { return nil }
                        
                        return Message(id: messageSnapshot.key, text: text, senderId: senderId, timestamp: timestamp)
                    }
                    
                    let chat = Chat(
                        id: childSnapshot.key,
                        participants: participants,
                        messages: messages
                    )
                    fetchedChats.append(chat)
                }
            }
            
            self?.chats = fetchedChats.sorted { $0.messages.last?.timestamp ?? 0 > $1.messages.last?.timestamp ?? 0 }
            self?.isLoading = false
        } withCancel: { [weak self] error in
            self?.isLoading = false
        }
    }


}
