//
//  Author.swift
//  L2Play
//
//  Created by Lukasz Fabia on 26/11/2024.
//

import Foundation

/// For denormalization purposes
struct Author: Codable {
    let email: String
    let name: String // lukasz + fabia (first + last name)
    let profilePicture: URL?
    
    /// Also you can use name as email
    init(email: String, name: String, profilePicture: URL?) {
        self.email = email
        self.profilePicture = profilePicture
        self.name = name
    }
    
    init(email: String, firstName: String, lastName: String, profilePicture: URL?) {
        self.email = email
        self.profilePicture = profilePicture
        self.name = String(describing: "\(firstName) \(lastName)")
    }
    
    init(user: User) {
        self.email = user.email
        self.profilePicture = user.profilePicture
        
        self.name = user.fullName()
    }
}
