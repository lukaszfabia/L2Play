//
//  User.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

struct User: Codable, Identifiable {
    private(set) var id: UUID = .init()
    let firstName: String
    let lastName: String
    let email: String
    let profilePicture: URL?
    let followers: [User]
    let following: [User]
    let playlist: [Game]
    let favGames: [Game]
    let blockedUsers: [User]
    let createdAt: Date
    
    static func dummy() -> User {
        let url: URL = URL(string: "https://placebeard.it/250/250")!
        
        let friend1 = User(
            firstName: "Marry",
            lastName: "Jane",
            email: "marry.jane@example.com",
            profilePicture: url,
            followers: [],
            following: [],
            playlist: [],
            favGames: [],
            blockedUsers: [],
            createdAt: Date()
        )
        
        return User(
            firstName: "Lukasz",
            lastName: "Fabia",
            email: "ufabia03@gmail.com",
            profilePicture: url,
            followers: dummyFriends(),
            following: [],
            //            playlist: [Game.dummy(), Game.dummy(), Game.dummy()],
            //            favGames: [Game.dummy(), Game.dummy()],
            playlist: [],
            favGames: [],
            blockedUsers: [friend1],
            createdAt: Date()
        )
    }
    
    static private func dummyFriends() -> [User] {
        let url: URL = URL(string: "https://placebeard.it/250/250")!
        
        let friend1 = User(
            firstName: "Marry",
            lastName: "Jane",
            email: "marry.jane@example.com",
            profilePicture: url,
            followers: [],
            following: [],
            playlist: [],
            favGames: [],
            blockedUsers: [],
            createdAt: Date()
        )
        
        let friend2 = User(
            firstName: "Joe",
            lastName: "Doe",
            email: "joe.doe@example.com",
            profilePicture: url,
            followers: [],
            following: [],
            playlist: [],
            favGames: [],
            blockedUsers: [],
            createdAt: Date()
        )
        
        return [friend1, friend2]
    }
}

