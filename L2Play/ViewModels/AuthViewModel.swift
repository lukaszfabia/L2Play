//
//  Provider.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation
import FirebaseAuth
import Firebase


class AuthViewModel: ObservableObject {
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
        
    }

    func continueWithGoogle() {
        
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
        } catch let error {
            self.errorMessage = error.localizedDescription
        }
    }
}

