//
//  Login.swift
//  ios
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import Foundation


protocol Validator{
    var email : String {get}
    var password: String {get}
    
    func validate() -> Bool
}

extension Validator {
    func isValidEmail(_ email: String) -> Bool {
           return email.contains("@") && email.contains(".")
       }
    
    func isValidPassword(_ password: String) -> Bool {
        return false
    }
    
    func isValidName(_ name: String) -> Bool {
        return false
    }
    
    func areValidPasses(email: String, password: String) -> Bool{
        return !(email.isEmpty || password.isEmpty)
    }
}

class RegisterValidator: Validator {
    var firstName: String
    var lastName: String
    var password: String
    var email: String
    
    required init(email: String, password: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    func validate() -> Bool{
        if !isValidEmail(email){
            return false
        }
        
        // validate password
        
        // validate first last name
        
        return true
    }
}

class LoginValidator: Validator {
    var email: String
    var password: String
    
    required init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    
    func validate() -> Bool {
        return areValidPasses(email: email, password: password)
    }
}
