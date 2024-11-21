//
//  UserController.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    private let manager: FirebaseManager = FirebaseManager()
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func fetchUserData() {
        
    }

    func updateUserData(newUsername: String, newEmail: String) {
  
    }
    
    func loginUser(email: String, password: String) {
      
    }
}
