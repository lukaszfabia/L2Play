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
    
    private let manager: FirebaseManager = FirebaseManager()
    
    init(game: Game, user: User) {
        self.game = game
        self.user = user
    }
    
    func refreshGame() async {
        do {
            self.game = try await manager.read(collection: "game", id: game.id.uuidString)
        } catch {}
    }
    
    func isOnList() -> Bool {
        return user.playlist.contains(game.id)
    }
    
    func toggleGameState(refreshUser: @escaping (_ user: User) async -> Void) {
        if isOnList() {
            //remove from list
            if let index = user.playlist.firstIndex(of: game.id) {
                user.playlist.remove(at: index)
            }
        } else {
            user.playlist.append(game.id)
        }
        
        
        Task(priority: .high) {
            print("witamy w togglegamestate")
            try await self.manager.update(collection: "users", id: user.email, object: user)
            await refreshUser(self.user)
        }
    }
}
