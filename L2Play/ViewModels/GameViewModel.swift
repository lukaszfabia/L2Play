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

    private let firebaseManager: FirebaseManager = FirebaseManager()
    private var user: User

    init(game: Game, user: User?) {
        self.game = game
        self.user = user!
    }

    func isOnList() -> Bool {
        return user.playlist.contains(game.id)
    }

    func toggleGameState() {
        if let index = user.playlist.firstIndex(of: game.id) {
            user.playlist.remove(at: index)
        } else {
            user.playlist.append(game.id)
        }
        
        firebaseManager.update(collection: "users", id: user.email, object: user) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Failed to update user's games: \(error.localizedDescription)")
            }
        }
    }
}
