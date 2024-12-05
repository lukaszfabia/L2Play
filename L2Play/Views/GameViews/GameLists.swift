//
//  GameLists.swift
//  L2Play
//
//  Created by Lukasz Fabia on 05/12/2024.
//

import SwiftUI

struct GameList: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var searched: String = ""
    @State private var filteredGames: [GameWithState] = []
    
    @State private var sorted: SortOption = .ascending
    @State private var sortProperty: SortAttributeForGame = .updatedAt
    
    
    var state: GameState
    var games: [GameWithState]
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Picker("Sort by", selection: $sortProperty) {
                        ForEach(SortAttributeForGame.allCases) { attribute in
                            Text(attribute.rawValue)
                                .tag(attribute)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    Picker("Order", selection: $sorted) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue.capitalized)
                                .tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                ForEach(filteredGames) { game in
                    NavigationLink(destination: LazyGameView(gameID: game.gameID, userViewModel: UserViewModel(user: provider.user))){
                        row(with: game)
                    }.buttonStyle(PlainButtonStyle())
                }
                .searchable(text: $searched, prompt: "Search game")
                .onChange(of: searched) { applyFilters() }
                .onChange(of: sorted) { applyFilters() }
                .onChange(of: sortProperty) { applyFilters() }
                .onAppear() { applyFilters() }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(state.rawValue.capitalized)
        }
    }
    
    func applyFilters() {
        if searched.isEmpty {
            filteredGames = games
        } else {
            filteredGames = games.filter {
                $0.name.contains(searched)
            }
        }
        
        filteredGames.sort {
            $0.compare(to: $1, attribute: sortProperty, order: sorted)
        }
    }

    
    private func row(with game: GameWithState) -> some View {
        HStack(spacing: 10) {
            GameCover(cover: game.pic, w: 100, h: 100)
            VStack(alignment: .leading) {
                Text(game.name)
                    .font(.headline)
                Text(game.studio)
                    .font(.subheadline)
                Text("Added \(game.updatedAt.timeAgoSinceDate())")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
}
