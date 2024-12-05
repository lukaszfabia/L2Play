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
                Text("First of all ")
                    .font(.headline)
                    .fontWeight(.thin)
                    .foregroundStyle(.secondary)
                GradientText(text: Text("Games"), customFontSize: .headline)
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
            }
            
            HStack (spacing: 0) {
                Text("And ")
                    .font(.headline)
                    .fontWeight(.thin)
                    .foregroundStyle(.secondary)
                GradientText(text: Text("Genres"), customFontSize: .headline)
            }.padding(.bottom, 5)
            
            VStack {
                // jakeis staty
            }
        }.padding()
    }
}

struct LazyGameView: View {
    let gameID: UUID
    @ObservedObject var userViewModel: UserViewModel
    @State private var game: Game?

    var body: some View {
        Group {
            if let game {
                GameView(gameViewModel: GameViewModel(game: game, user: userViewModel.user!))
            } else {
                ProgressView("Loading game...")
                    .task {
                        game = await userViewModel.fetchGame(with: gameID)
                    }
            }
        }
    }
}

