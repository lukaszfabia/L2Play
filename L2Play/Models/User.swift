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
    let firstName: String?
    let lastName: String?
    let email: String
    let profilePicture: URL?
    let followers: [User]
    let following: [User]
    let playlist: [Game]
    let favGames: [Game]
    let blockedUsers: [User]
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
    
    init(firstName: String, lastName: String, email: String, avatar: URL, playlist: [Game], favGames: [Game], blockedUsers: [User], followers: [User], following: [User]) {
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
    
    // Funkcja do generowania danych testowych
    static func dummy() -> User {
        let url = URL(string: "https://placebeard.it/250/250")!
        let friend1 = User(
            firstName: "Marry",
            lastName: "Jane",
            email: "marry.jane@example.com",
            avatar: url
        )
        
        
        return User(firstName: "Lukasz", lastName: "Fabia", email: "ufabia03@gmail.com", avatar: url, playlist: [], favGames: [], blockedUsers: dummyFriends(), followers: [friend1], following: [])
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
