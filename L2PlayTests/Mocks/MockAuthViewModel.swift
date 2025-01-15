//
//  MockAuthViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 15/01/2025.
//

import SwiftUI

@MainActor
class MockAuthViewModel: AuthViewModel {
    private let demandedEmail: String = "joe.doe@example.com"
    private let demandedPassword: String = "P@ssw0rd2003!!"

    override init() {
        super.init()
    }
    
    override func login(email: String, password: String) {
        self.isLoading = true
        defer { self.isLoading = false }

        let ok = demandedEmail == email && password == demandedPassword

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Task { @MainActor in
                if ok {
                    self.isAuthenticated = true
                    self.errorMessage = nil
                    self.user = User.dummy()
                } else {
                    self.isAuthenticated = false
                    self.errorMessage = "Invalid email or password"
                }
            }
        }
    }
    
    override func signUp(email: String, password: String, firstName: String, lastName: String) {
        self.isLoading = true
        defer { self.isLoading = false }

        let av = AuthValidator(firstName: firstName, lastName: lastName, email: email, password: password)

        guard av.validateSignUp() else {
            self.errorMessage = "Invalid password or login"
            return
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.user = User.dummy()
            }
        }
    }
}
