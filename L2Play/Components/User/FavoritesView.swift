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
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Favourites")
                .font(.largeTitle)
                .fontWeight(.light)
            
            HStack (spacing: 0) {
                Text("First of all Games")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }.padding(.bottom, 5)
            
            if favs.isEmpty {
                Text("No favourites yet.")
                    .foregroundStyle(.secondary)
            } else {
                CustomPageSlider(data: $favs) { $item in
                    NavigationLink(destination: LazyGameView(gameID: item.game.gameID, userViewModel: userViewModel)) {
                        FavoriteGamesRow(game: item.game)
                    }
                } titleContent: { _ in }
                    .safeAreaPadding([.horizontal, .vertical], 10)
            }
    
            VStack {
                // jakeis staty
            }
        }.padding()
    }
}
