//
//  User.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation
import FirebaseAuth

struct User: Codable, Identifiable {
    var id: UUID = .init()
    var firstName: String?
    var lastName: String?
    var email: String
    let profilePicture: URL?
    // swap on uuid
    var followers: [UUID]
    var following: [UUID]
    var playlist: [UUID]
    var favGames: [UUID]
    var blockedUsers: [UUID]
    let createdAt: Date
    

    init(firebaseUser: FirebaseAuth.User) {

        if let name = firebaseUser.displayName {
            let components = name.split(separator: " ")
            self.firstName = components.first.map { String($0) }
            self.lastName = components.dropFirst().joined(separator: " ")
        } else {
            self.firstName = nil
            self.lastName = nil
        }
        
    
        self.email = firebaseUser.email ?? "unknown@example.com"
        if let photoURL = firebaseUser.photoURL {
            self.profilePicture = photoURL
        } else {
            self.profilePicture = nil
        }
        
        self.followers = []
        self.following = []
        self.playlist = []
        self.favGames = []
        self.blockedUsers = []
        self.createdAt = Date() // timestamp create
    }
    
    init(firstName: String, lastName: String, email: String, avatar: URL? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePicture = avatar
        self.followers = []
        self.following = []
        self.playlist = []
        self.favGames = []
        self.blockedUsers = []
        self.createdAt = Date()
    }
    
    init(firstName: String, lastName: String, email: String, avatar: URL, playlist: [UUID], favGames: [UUID], blockedUsers: [UUID], followers: [UUID], following: [UUID]) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePicture = avatar
        self.followers = followers
        self.following = following
        self.playlist = playlist
        self.favGames = favGames
        self.blockedUsers = blockedUsers
        self.createdAt = Date()
    }
    
    static func dummy() -> User {
        let url = URL(string: "https://placebeard.it/250/250")!
    
        return User(firstName: "guest", lastName: "g", email: "guest@example.com", avatar: url, playlist: [], favGames: [], blockedUsers: [], followers: [], following: [])
    }
    
  
    static private func dummyFriends() -> [User] {
        let url = URL(string: "https://placebeard.it/250/250")!
        
        let friend1 = User(
            firstName: "Marry",
            lastName: "Jane",
            email: "marry.jane@example.com",
            avatar: url
        )
        
        let friend2 = User(
            firstName: "Joe",
            lastName: "Doe",
            email: "joe.doe@example.com",
            avatar: url
        )
        
        return [friend1, friend2]
    }
}