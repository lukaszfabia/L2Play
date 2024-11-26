//
//  GameViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var game: Game
    @Published private(set) var user: User
    @Published var errorMessage: String = ""
    @Published var reviews: [Review] = []
    
    private let manager: FirebaseManager = FirebaseManager()
    
    init(game: Game, user: User) {
        self.game = game
        self.user = user
    }
    
    func refreshGame() async {
        do {
            self.game = try await manager.read(collection: .games, id: game.id.uuidString)
            
            await self.fetchReviewsForGame()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func isOnList() -> Bool {
        return user.playlist.contains(game.id)
    }
    
    func isFav() -> Bool {
        return user.favGames.contains(game.id)
    }
    
    private func toggleGame(for keyPath: WritableKeyPath<User, [UUID]>, refreshUser: @escaping (_ user: User) async -> Void) {
        if user[keyPath: keyPath].contains(game.id) {
            if let index = user[keyPath: keyPath].firstIndex(of: game.id) {
                user[keyPath: keyPath].remove(at: index)
            }
        } else {
            user[keyPath: keyPath].append(game.id)
        }
        
        Task(priority: .high) {
            try await self.manager.update(collection: .users, id: user.email, object: user)
            await refreshUser(self.user)
        }
    }
    
    func toogleFavGameState(refreshUser: @escaping (_ user: User) async -> Void){
        toggleGame(for: \.favGames, refreshUser: refreshUser)
    }
    
    func toggleGameState(refreshUser: @escaping (_ user: User) async -> Void) {
        toggleGame(for: \.playlist, refreshUser: refreshUser)
    }
    
    @MainActor
    func fetchReviewsForGame() async {
        do {
            let reviews: [Review] = try await manager.findAll(collection: .reviews, whereIs: ("gameID", self.game.id.uuidString))
            
            self.reviews = reviews
        } catch let err {
            self.errorMessage = "Failed to fetch reviews: \(err.localizedDescription)"
            return
        }
    }
}
