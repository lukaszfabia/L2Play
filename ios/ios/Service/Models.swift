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


struct User: Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let profilePicture: URL
    let followers: [User]
    let following: [User]
    let playlist: [Game]
    let favGames: [Game]
    let createdAt: Date
    
    static func dummy() -> User {
        let url: URL = URL(string: "https://placebeard.it/250/250")!
        
        return User(
            id: UUID(),
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
            createdAt: Date()
        )
    }
    
    static private func dummyFriends() -> [User] {
        let url: URL = URL(string: "https://placebeard.it/250/250")!
        
        let friend1 = User(
            id: UUID(),
            firstName: "Marry",
            lastName: "Jane",
            email: "marry.jane@example.com",
            profilePicture: url,
            followers: [],
            following: [],
            playlist: [],
            favGames: [],
            createdAt: Date()
        )
        
        let friend2 = User(
            id: UUID(),
            firstName: "Joe",
            lastName: "Doe",
            email: "joe.doe@example.com",
            profilePicture: url,
            followers: [],
            following: [],
            playlist: [],
            favGames: [],
            createdAt: Date()
        )
        
        return [friend1, friend2]
    }
}


struct Tag: Codable {
    let id: UUID
    let name: String
}

struct Comment: Codable, Identifiable {
    let id : UUID
    let createdAt: Date
    let comment: String
    let author: User
    
    static func dummy() -> Comment {
        let url: URL = URL(string: "https://placebeard.it/250/250")!
        return Comment(id: UUID(), createdAt: Date(), comment: "test test tes test testtestss", author: User(
            id: UUID(),
            firstName: "Joe",
            lastName: "Doe",
            email: "joe.doe@example.com",
            profilePicture: url,
            followers: [],
            following: [],
            playlist: [],
            favGames: [],
            createdAt: Date()
        ))
    }
}

struct Review: Codable, Identifiable {
    let id : UUID
    let createdAt: Date
    let review: String
    let rating: Int
    let author: User
    let comments: [Comment]
    
    static func dummy() -> Review {
        return Review(id: UUID(), createdAt: Date(), review: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio velit, accumsan id erat sed, faucibus tristique lectus. Sed condimentum libero scelerisque tincidunt scelerisque. Nulla venenatis tellus id erat mollis, eget cursus lorem dignissim. Sed luctus hendrerit nisi id molestie. Integer enim lorem, lacinia a dignissim sit amet, ullamcorper et nunc.", rating: 8, author: User.dummy(), comments: [Comment.dummy(),Comment.dummy(),Comment.dummy(),Comment.dummy()])
    }
}

struct Game: Codable {
    let id : UUID
    let name: String
    let studio : String
    let tags: [Tag]
    let pictures: [URL]
    let description : String
    let popularity: Int
    let community: Int
    let reviews: [Review]
    let releaseYear: Int?
    let rating: Double
    let platform: [String]
    let multiplayerSupport: Bool
    let price: Double?
    let developers: [String]?
    
    static func dummy() -> Game {
        return Game(
            id: UUID(),
            name: "League of Legends",
            studio: "Riot Games",
            tags: [Tag(id: UUID(), name: "Action"), Tag(id: UUID(), name: "Adventure"), Tag(id: UUID(), name: "Strategy"), Tag(id: UUID(), name: "Multiplayer")],
            pictures: [URL(string: "https://cdn1.epicgames.com/offer/24b9b5e323bc40eea252a10cdd3b2f10/EGS_LeagueofLegends_RiotGames_S2_1200x1600-905a96cea329205358868f5871393042")!, URL(string: "https://interfaceingame.com/wp-content/uploads/league-of-legends/league-of-legends-cover-375x500.jpg")!],
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio velit, accumsan id erat sed, faucibus tristique lectus. Sed condimentum libero scelerisque tincidunt scelerisque. Nulla venenatis tellus id erat mollis, eget cursus lorem dignissim. Sed luctus hendrerit nisi id molestie. Integer enim lorem, lacinia a dignissim sit amet, ullamcorper et nunc.",
            popularity: 1,
            community: 987654,
            reviews: [Review.dummy(), Review.dummy()],
            releaseYear: 2009,
            rating: 4.5,
            platform: ["Windows", "MacOS", "Linux"],
            multiplayerSupport: true,
            price: nil,
            developers: ["Developer 1", "Developer 2"]
        )
    }
}
