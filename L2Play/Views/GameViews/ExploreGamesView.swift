//
//  ExploreGamesView.swift
//  ios
//
//  Created by Lukasz Fabia on 27/10/2024.
//

import SwiftUI

struct ExploreGamesView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var filteredGames: [Game] = []
    @StateObject private var gamesViewModel = GamesViewModel()
    @State private var searchText: String = ""
    @State private var navigateToSearchResults = false
    @State private var sortOrder: SortOrder = .ascending
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Recommendations for You")
                        .fontWeight(.light)
                        .font(.title)
                        .padding(.horizontal)
                    
                    if gamesViewModel.recommendedGames.isEmpty {
                        Text("There is no recommendations for you yet.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        CustomPageSlider(data: $gamesViewModel.recommendedGames) { $item in
                            NavigationLink(destination: GameView(gameViewModel: GameViewModel(game: item.game, user: provider.user))) {
                                GameRecommendationView(game: item.game)
                            }
                        } titleContent: { $item in
                            VStack(spacing: 10) {
                                Text(item.title)
                                    .font(.title.bold())
                                Text(item.subTitle)
                                    .multilineTextAlignment(.center)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(height: 45)
                                    .padding(.bottom, 5)
                            }
                        }
                        .padding(.top, 20)
                        .padding([.horizontal, .bottom], 35)
                    }
                    
                    if searchText.isEmpty {
                        popular()
                    } else {
                        searching()
                    }
                    
                }
            }
            .searchable(text: $searchText, placement: .automatic, prompt: "Search...")
            .onSubmit(of: .search) {
                navigateToSearchResults = true
            }
            .navigationTitle("Explore Games")
        }
        .onAppear {
            Task {
                await gamesViewModel.fetchGames()
            }
        }
    }
    
    private func applyFilters() {
        filteredGames = gamesViewModel.games.filter { game in
            game.name.lowercased().contains(searchText.lowercased()) ||
            game.tags.contains(where: { $0.lowercased().contains(searchText.lowercased()) }) ||
            game.studio.contains(where: { $0.lowercased().contains(searchText.lowercased()) })
        }
        .sorted { sortOrder == .ascending ? $0.name < $1.name : $0.name > $1.name }
    }
    
    private func searching() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Results for '\(searchText)'")
                    .fontWeight(.light)
                    .font(.title)
                Image(systemName: "magnifyingglass")
                    .font(.title)
            }
            .padding(.horizontal)
            
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(filteredGames, id: \.id) { game in
                    GameRow(gameViewModel: GameViewModel(game: game, user: provider.user))
                }
            }
            .padding([.horizontal, .top], 20)
        }
        .onAppear { applyFilters() }
        .onChange(of: searchText) { applyFilters() }
        .onChange(of: sortOrder) { applyFilters() }
    }
    
    
    private func popular() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Currently Popular")
                    .fontWeight(.light)
                    .font(.title)
                Image(systemName: "arrow.up.right")
                    .font(.title)
            }
            .padding(.horizontal)
            
            if gamesViewModel.games.isEmpty {
                LoadingView()
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(gamesViewModel.games, id: \.id) { game in
                        GameRow(gameViewModel: GameViewModel(game: game, user: provider.user))
                    }
                }
                .padding([.horizontal, .top], 20)
            }
        }
    }
}
