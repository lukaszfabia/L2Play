//
//  Author.swift
//  L2Play
//
//  Created by Lukasz Fabia on 26/11/2024.
//

import Foundation

/// For denormalization purposes
struct Author: Codable {
    let userID: UUID
    let name: String // lukasz + fabia (first + last name)
    let profilePicture: URL?
    
    /// Also you can use name as email
    init(userID: UUID, name: String, profilePicture: URL?) {
        self.userID = userID
        self.profilePicture = profilePicture
        self.name = name
    }
    
    init(userID: UUID, firstName: String, lastName: String, profilePicture: URL?) {
        self.userID = userID
        self.profilePicture = profilePicture
        self.name = String(describing: "\(firstName) \(lastName)")
    }
    
    init(user: User) {
        self.userID = user.id
        self.profilePicture = user.profilePicture
        
        if let fname = user.firstName, let lname = user.lastName {
            self.name = String(describing: "\(fname) \(lname)")
        } else {
            self.name = user.email
        }
    }
}
