//
//  Provider.swift
//  L2Play
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
    private let manager = FirebaseManager()
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
            let fetchedUser: User = try await self.manager.read(collection: .users, id: user.email)
            
            DispatchQueue.main.async {
                self.user = fetchedUser
                self.setInCtx()
            }
        } catch let err {
            print("Failed to refresh user: \(err.localizedDescription)")
            DispatchQueue.main.async {
                self.errorMessage = "Failed to refresh user."
            }
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
                    self.manager.delete(collection: .users, id: email) { result in
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
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "Failed to retrieve client ID."
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        self.isLoading = true
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleAuthError(message: "Google sign-in failed.", error: error)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.handleAuthError(message: "Failed to retrieve Google token.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.handleAuthError(message: "Firebase authentication failed.", error: error)
                    return
                }
                
                guard let firebaseUser = result?.user else {
                    self.handleAuthError(message: "Failed to authenticate user.")
                    return
                }
                
                self.handleUser(user: User(firebaseUser: firebaseUser))
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
        Task(priority: .high) {
            do {
                
                let user: User = try await self.manager.read(collection: .users, id: user.email)
                
                DispatchQueue.main.async {
                    self.user = user
                    self.isAuthenticated = true
                    self.setInCtx()
                }
            } catch {
                do {
                    let user: User = try await self.manager.create(
                        collection: .users,
                        object: user,
                        uniqueFields: ["email"],
                        uniqueValues: [user.email],
                        customID: user.email
                    )
                    
                    DispatchQueue.main.async {
                        self.user = user
                        self.isAuthenticated = true
                        self.setInCtx()
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        self.handleAuthError(message: "Failed to create user in database.", error: error)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
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

