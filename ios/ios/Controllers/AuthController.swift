//
//  Login.swift
//  ios
//
//  Created by Lukasz Fabia on 06/10/2024.
//

import Foundation

struct LoginData: Codable {
    let email: String
    let password: String
}


struct RegisterData: Codable {
    let passes: LoginData
    let firstName: String
    let lastName: String
}

class AuthController{
    public func loginWithGoogle() async {
        
    }
    
    public func login(logindata: LoginData) async -> Tokens {
        var tokens : Tokens = Tokens(access: "", refresh: "")
        
        var data: Data?
        
        do {
            data = try JSONEncoder().encode(logindata)
        } catch {
            print("Could't encode data: ", error)
            return tokens
        }
        
        
        do {
            let responseData = try await ApiService().fetch(path: "users/login/", method: Method.POST, data: data)
            
            
            tokens = try JSONDecoder().decode(Tokens.self, from: responseData)
        } catch {
            print("Error during API request:", error)
        }
        
        return tokens
    }
    
    public func register() async{
        
    }
    
    public func logout(){
        
    }
}
