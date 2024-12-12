//
//  ExploreGamesView.swift
//  ios
//
//  Created by Lukasz Fabia on 27/10/2024.
//

import SwiftUI

struct ExploreGamesView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject private var userViewModel: UserViewModel
    @State private var filteredGames: [Game] = []
    @State private var games: [Game] = []
    @State private var recommendations: [Item] = []
    @State private var searchText: String = ""
    @State private var navigateToSearchResults = false
    
    init(user: User) {
        self._userViewModel = StateObject(wrappedValue: UserViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Recommendations for You")
                        .fontWeight(.light)
                        .font(.title)
                        .padding(.horizontal)
                    
                    if recommendations.isEmpty {
                        Text("There is no recommendations for you yet.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .padding()
                    } else {
                        CustomPageSlider(data: $recommendations) { $item in
                            NavigationLink(destination: LazyGameView(gameID: item.game.gameID, userViewModel: UserViewModel(user: provider.user))) {
                                GameRecommendationView(game: item.game)
                            }
                        } titleContent: { _ in }
                            .safeAreaPadding([.horizontal, .vertical], 10)
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
                games = await userViewModel.fetchGames()
                recommendations = await provider.fetchRecommendations()
            }
        }
    }
    
    private func applyFilters() {
        filteredGames = games.filter { game in
            game.name.lowercased().contains(searchText.lowercased()) ||
            game.tags.contains(where: { $0.lowercased().contains(searchText.lowercased()) }) ||
            game.studio.lowercased().contains(searchText.lowercased())
        }
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
                    GameRow(gameViewModel: GameViewModel(game: game, user: userViewModel.user!))
                }
            }
            .padding([.horizontal, .top], 20)
        }
        .onAppear { applyFilters() }
        .onChange(of: searchText) { applyFilters() }
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
            
            if games.isEmpty {
                LoadingView()
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(games, id: \.id) { game in
                        GameRow(gameViewModel: GameViewModel(game: game, user: userViewModel.user!))
                    }
                }
                .padding([.horizontal, .top], 20)
            }
        }
    }
}
