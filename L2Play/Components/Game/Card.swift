//
//  Card.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct GameCard: View {
    let gameViewModel: GameViewModel
    
    var body: some View {
        NavigationLink(destination: GameView(gameViewModel: gameViewModel)) {
            HStack(spacing: 12) {
                GameCover(cover: gameViewModel.game.pictures[0])
            }
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}