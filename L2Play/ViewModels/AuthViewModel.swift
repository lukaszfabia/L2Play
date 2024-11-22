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


class AuthViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager()
    
    @Published var isAuthenticated: Bool = false
    @Published var user: User? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    
    init(isAuthenticated: Bool, user: User? = nil) {
        self.isAuthenticated = isAuthenticated
        self.user = user
    }
    
    
    init() {
        self.isAuthenticated = false
        self.user = nil
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
                    }
                }
            }
        }
    }
    
    
    func signUp(email: String, password: String, firstName: String, lastName: String) {
        self.isLoading = true
        print("validacja")
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
        
        
        print("tworznie usera")
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
                        self.isLoading = false
                        switch result {
                        case .failure(let error):
                            self.errorMessage = "Failed to auth user: \(error.localizedDescription)"
                            
                        case .success(let user):
                            self.user = user
                            self.isAuthenticated = true
                        }
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
            self.user = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

