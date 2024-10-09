//
//  UserController.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation

class UserController{
    func getUser(_ provider: AuthProvider) async -> User? {
        var user : User?
        do {
            if let t = provider.tokens {
                let responseData = try await ApiService().fetch(path: "users/", method: Method.GET, authToken: t.access)
                
                
                user = try JSONDecoder().decode(User.self, from: responseData)
                
                return user
            }
        } catch {
            print("Error during API request:", error)
        }
        
        return nil
    }
}
