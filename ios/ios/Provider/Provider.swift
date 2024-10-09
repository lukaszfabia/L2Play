//
//  Provider.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation

class AuthProvider: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var tokens: Tokens? = nil
    @Published var user : User? = nil
    
    init(isAuthenticated: Bool, tokens: Tokens? = nil, user: User? = nil) {
        self.isAuthenticated = isAuthenticated
        self.tokens = tokens
        self.user = user
    }
    
    init() {
        self.tokens = nil
        self.isAuthenticated = false
        self.user = nil
    }
    
    func logout() {
        self.user = nil
        self.isAuthenticated = !self.isAuthenticated
        self.tokens = nil
    }
    
    func setCredentials(isAuth: Bool, tokens: Tokens, user: User){
        self.isAuthenticated=isAuth
        self.tokens=tokens
        self.user = user
    }
}
