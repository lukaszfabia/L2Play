//
//  Author.swift
//  L2Play
//
//  Created by Lukasz Fabia on 26/11/2024.
//

import Foundation

/// For denormalization purposes
struct Author: Codable {
    let id: String
    let name: String // full name
    let profilePicture: URL?
    
    init(id: String, name: String, profilePicture: URL?) {
        self.id = id
        self.name = name
        self.profilePicture = profilePicture
    }
    
    init(id: String, name: String, profilePicture: String?) {
        let url = profilePicture.flatMap { URL(string: $0) }
        self.init(id: id, name: name, profilePicture: url)
    }
    
    init(id: String, firstName: String, lastName: String, profilePicture: URL?) {
        let fullName = "\(firstName) \(lastName)"
        self.init(id: id, name: fullName, profilePicture: profilePicture)
    }
    
    init(user: User) {
        self.init(id: user.id, name: user.fullName(), profilePicture: user.profilePicture)
    }
    
    init?(from decoder: [String: Any]) {
        guard
            let id = decoder["id"] as? String,
            let name = decoder["name"] as? String
        else {
            return nil
        }
        
        let profilePicture = decoder["profilePicture"] as? String

        self.id = id
        self.name = name
        self.profilePicture = profilePicture.flatMap { URL(string: $0) }
    }

    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": id,
            "name": name
        ]
        
        if let profilePicture = profilePicture {
            dictionary["profilePicture"] = profilePicture.absoluteString
        }
        
        return dictionary
    }
}
