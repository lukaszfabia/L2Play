//
//  FavoritesView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI
import Foundation
import Charts

protocol GameKey: Hashable {}

extension String: GameKey {}
extension GameState: GameKey {}

private struct GameData<T: GameKey>: Identifiable, Equatable {
    let id: UUID = .init()
    let key: T
    let count: Int
    
    init(key: T, count: Int) {
        self.key = key
        self.count = count
    }
    
    static func toList(lst: [[T: Int]], max: Int? = nil) -> [GameData<T>] {
        let r = Array(
            lst.compactMap { dict in
                dict.map { GameData(key: $0.key, count: $0.value) }
            }
            .flatMap { $0 }
            .sorted { $0.count > $1.count }
        )
        
        if let max = max {
            return Array(r.prefix(max))
        }
        
        return r
    }

}
// TODO: move preprocess game to user viwe 
struct FavoritesView: View {
    @Binding var favs: [Item]
    @ObservedObject var userViewModel: UserViewModel
    @State private var stateData: [GameData<GameState>] = []
    @State private var tagsData: [GameData<String>] = []
    @State private var triedToFetch: Bool = false
    
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
            
            VStack(alignment: .leading) {
                if stateData.isEmpty && tagsData.isEmpty && !triedToFetch {
                    LoadingView().task {
                        await preprocessGames()
                    }
                } else if stateData.isEmpty && tagsData.isEmpty && triedToFetch {
                    Text("Add to your collection some games to see some mysterious magic happen!")
                        .font(.headline)
                } else {
                    TabView {
                        VStack {
                            Text("Current states of your games")
                                .font(.headline)
                            
                            Chart(stateData) { item in
                                BarMark(
                                    x: .value("State", item.key.rawValue),
                                    y: .value("Count", item.count)
                                )
                                .foregroundStyle(by: .value("State", item.key.rawValue))
                            }
                            .frame(height: 300)
                            .padding()
                        }
                        
                        VStack {
                            Text("Your most popular tags")
                                .font(.headline)
                            
                            Chart(tagsData) { item in
                                BarMark(
                                    x: .value("Tag", item.key),
                                    y: .value("Count", item.count)
                                )
                                .foregroundStyle(by: .value("Tag", item.key))
                            }
                            .frame(height: 300)
                            .padding()
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(width: 300, height: 400)
                    .cornerRadius(30)
                }
            }
        }.padding()
    }
    
    private func preprocessGames() async {
        guard let user = userViewModel.user else {return}
        
        triedToFetch = true
        
        stateData = GameData<GameState>
            .toList(lst: user.computeGameStateAndCard())
        
        let games = await userViewModel.fetchGames(ids: user.games.map{
            $0.gameID
        })
        
        tagsData = GameData<String>
            .toList(lst: user.computeFavoriteTags(games: games), max: 5)
        
        print(tagsData)
        
    }
}
