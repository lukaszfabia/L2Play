//
//  User.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import Foundation
import FirebaseAuth

class User: Codable, Identifiable, Hashable {
    let id: String
    var firstName: String?
    var lastName: String?
    var email: String
    var profilePicture: URL?
    var followers: [String]
    var following: [String]
    var games: [GameWithState]
    var blockedUsers: [String]
    let createdAt: Date
    var chats: [String]
    var isMod: Bool = false
    
    // MARK: - Hashable & Equatable
    static func ==(lhs: User, rhs: User) -> Bool {
         return lhs.id == rhs.id
     }

     func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
    
    // MARK: - Helper Methods
    func hasBlocked(_ userID: String) -> Bool {
        return blockedUsers.contains(userID)
    }
    
    func isFollowing(_ userID: String) -> Bool {
        return following.contains(userID)
    }
    
    func isFollowed(_ userID: String) -> Bool {
        return followers.contains(userID)
    }
    
    func fullName() -> String {
        if let firstName, let lastName {
            return "\(firstName) \(lastName)"
        } else {
            return String(email.split(separator: "@")[0])
        }
    }
    
    func toggleGame(game: Game, state: GameState) {
        if let i = games.firstIndex(where: {$0.name == game.name}) {
            games[i].changeState(to: state)
        } else {
            let newGame = GameWithState(game: game, state: state)
            games.append(newGame)
        }
    }
    
    func computeGameStateAndCard() -> [[GameState: Int]] {
        return Dictionary(grouping: games, by: \.state)
            .mapValues{$0.count}
            .map{[$0.key : $0.value]}
    }
    
    func computeFavoriteTags(games: [Game]) -> [[String: Int]] {
        return games.map { game in
            game.tags.reduce(into: [:]) { counts, tag in
                counts[tag, default: 0] += 1
            }
        }
    }


    
    func splitByState() -> [GameState: [GameWithState]] {
        return Dictionary(grouping: games, by: { $0.state })
    }

    
    func toggleFollowStatus(_ otherUser: inout User) {
        guard self != otherUser else { return }
        
        if isFollowing(otherUser.id) {
            following.removeAll(where: {$0 == otherUser.id})
            otherUser.followers.removeAll(where: {$0 == id})
        } else {
            following.append(otherUser.id)
            otherUser.followers.append(id)
        }
    }
    
    
    // during removing returns false
    // during blocking returns true
    func block(who otherUser: inout User) -> Bool {
        guard self != otherUser else {return false}
        
        if hasBlocked(otherUser.id) {
            blockedUsers.removeAll(where: {$0 == otherUser.id})
            return false
        } else {
            blockedUsers.append(otherUser.id)
            
            // add skutki blocku
            
            // out followersi
            following.removeAll(where: {$0 == otherUser.id})
            followers.removeAll(where: {$0 == otherUser.id})
            
            otherUser.following.removeAll(where: {$0 == id})
            otherUser.followers.removeAll(where: {$0 == id})
            
            // out wiadmosci
            // TODO
            
            return true
        }
    }
    
    func getCurrentGameState(where id: UUID) -> GameState {
        if let i = games.firstIndex(where: {$0.gameID == id}) {
            return games[i].state
        } else {
            return .notPlayed
        }
    }
    
    // MARK: - Initializers
    init(firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        if let name = firebaseUser.displayName {
            let components = name.split(separator: " ")
            self.firstName = components.first.map { String($0) }
            self.lastName = components.dropFirst().joined(separator: " ")
        } else {
            self.firstName = nil
            self.lastName = nil
        }
        self.email = firebaseUser.email ?? "unknown@example.com"
        self.profilePicture = firebaseUser.photoURL
        self.followers = []
        self.following = []
        self.games = []
        self.blockedUsers = []
        self.chats = []
        self.createdAt = Date()
    }
    
    init(id: String, firstName: String, lastName: String, email: String, avatar: URL? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePicture = avatar
        self.followers = []
        self.following = []
        self.games = []
        self.blockedUsers = []
        self.chats = []
        self.createdAt = Date()
    }
    
    // MARK: - Dummy User
    static func dummy() -> User {
        let url = URL(string: "https://placebeard.it/250/250")!
        return User(id: "asb", firstName: "guest", lastName: "g", email: "guest@example.com", avatar: url)
    }
}
