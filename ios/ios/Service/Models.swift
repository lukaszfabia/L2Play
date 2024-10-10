//
//  Response.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//  File contains models from API

import Foundation

struct Tokens: Codable {
    let access: String
    let refresh: String
    
    static func dummy() -> Tokens{
        return Tokens(
            access: "sjdfgffgksdgfkg34843yfksjdgvckjsdQEWQR32fjgsdc",
            refresh: "ksjdgfk34gkjfsdbcskdbjvksdjvhsvouihwr")
    }
}




/*
 Handling Users and friend requests
 */
struct FriendRequest: Codable {
    let sender : User
    let recevier : User
    let status : String
    let create_at: Date
}

struct User: Codable {
    let id : UUID
    let first_name: String
    let last_name : String
    let email: String
    let profile_picture: URL
    let friends : [User]
    let friend_requests : [FriendRequest]
    let created_at: Date
    
    static func dummy() -> User{
        let url: URL = URL(string: "https://placebeard.it/250/250")!
        
        return  User(
            id: UUID(),
            first_name: "Lukasz",
            last_name: "Fabia",
            email: "ufabia03@gmail.com",
            profile_picture: url,
            friends: dummyFriend(),
            friend_requests: [],
            created_at: Date()
        )
    }
    
    
    static private func dummyFriend() -> [User] {
        let url: URL = URL(string: "https://placebeard.it/250/250")!
        
        let friend1 = User(
            id: UUID(),
            first_name: "Marry",
            last_name: "Jane",
            email: "marry.jane@example.com",
            profile_picture: url,
            friends: [],
            friend_requests: [],
            created_at: Date()
        )
        
        let friend2 = User(
            id: UUID(),
            first_name: "Joe",
            last_name: "Doe",
            email: "joe.doe@example.com",
            profile_picture: url,
            friends: [],
            friend_requests: [],
            created_at: Date()
        )
        return [friend1, friend2]
    }
}

