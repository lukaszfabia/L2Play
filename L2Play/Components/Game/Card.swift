//
//  Card.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct GameCard: View {
    var game: Game
    
    var body: some View {
        NavigationLink(destination: GameView(game: game)) {
            HStack(spacing: 12) {
                GameCover(cover: game.pictures[0])
            }
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}
