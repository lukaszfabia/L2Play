//
//  FavoritesView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI
import Foundation

struct FavoritesView: View {
    @Binding var favs: [Item]
    @EnvironmentObject var provider: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Favourites")
                .font(.largeTitle)
                .fontWeight(.light)
            
            if favs.isEmpty {
                Text("No favourites yet.")
                    .foregroundStyle(.secondary)
            } else {
                CustomPageSlider(data: $favs) { $item in
                    let gm = GameViewModel(game: item.game, user: provider.user)
                    NavigationLink(destination: GameView(gameViewModel: gm)) {
                        FavoriteGamesRow(gameViewModel: gm)
                    }
                } titleContent: { _ in }
                .safeAreaPadding([.horizontal, .top, .bottom], 25)
            }
        }
    }
}
