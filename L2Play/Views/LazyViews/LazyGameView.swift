//
//  LazyGameView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 10/12/2024.
//

import SwiftUI

struct LazyGameView: View {
    let gameID: UUID
    @ObservedObject var userViewModel: UserViewModel
    @State private var game: Game?

    var body: some View {
        Group {
            if let game {
                GameView(gameViewModel: GameViewModel(game: game, user: userViewModel.user!))
            } else {
                ProgressView("Loading game")
                    .task {
                        game = await userViewModel.fetchGame(with: gameID)
                    }
            }
        }
    }
}

