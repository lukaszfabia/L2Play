//
//  AuthValidator.swift
//  L2Play
//
//  Created by Lukasz Fabia on 22/11/2024.
//

class AuthValidator {
    private let firstName: String
    private let lastName : String
    private let email: String
    private let password: String
    
    init(firstName: String, lastName: String, email: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
    
    
    static func compare(providedEmail: String, currentEmail: String) -> Bool {
        return providedEmail.localizedLowercase.elementsEqual(currentEmail.localizedLowercase)
    }
    
    private func validate(names: String...) -> Bool {
        for name in names {
            if name.isEmpty || name.count > 30 {
                return false
            }
        }
        
        return true
    }
    
    
    private func validate(password: String) -> Bool {
        if password.isEmpty {
            return false
        }
        
        do {
            let reg = try Regex(#"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\^$*.\[\]{}()?\"!@#%&/\\,><':;|_~])[A-Za-z\d\^$*.\[\]{}()?\"!@#%&/\\,><':;|_~]{6,4096}$"#)
            
            let isValid = try reg.firstMatch(in: password) != nil
            
            return isValid
        } catch {
            return false
        }
    }
    
    private func validate(email: String) -> Bool {
        if email.count > 100 || email.count < 3  || email.isEmpty{
            return false
        }
        do {
            let reg = try Regex("(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
            
            let isValid = try reg.firstMatch(in: email) != nil
            return isValid
        } catch {
            return false
        }
    }
    
    
    func validateSignUp() -> Bool {
        if !validate(email: self.email) {
            return false
        }
        
        if !validate(password: self.password) {
            return false
        }
        
        if !validate(names: self.firstName, self.lastName) {
            return false
        }
        
        return true
    }
    
    
}
