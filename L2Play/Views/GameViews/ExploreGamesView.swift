//
//  ExploreGamesView.swift
//  ios
//
//  Created by Lukasz Fabia on 27/10/2024.
//

import SwiftUI

// TODO: optionally we can add some filters to search easier

struct ExploreGamesView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject private var gamesViewModel = GamesViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Recommendations for You")
                        .fontWeight(.light)
                        .font(.title)
                        .padding(.horizontal)

                    if gamesViewModel.recommendedGames.isEmpty {
                        Text("There is no recommendations for you yet.").font(.subheadline).foregroundStyle(.secondary).padding()
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
                        .safeAreaPadding([.horizontal, .top, .bottom], 35)
                    }

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
                            ProgressView()
                        } else {
                            LazyVStack(alignment: .leading, spacing: 10) {
                                ForEach(gamesViewModel.games, id: \.id) { game in
                                    GameRow(gameViewModel: GameViewModel(game: game, user: provider.user))
                                }
                            }
                            .safeAreaPadding([.horizontal, .top], 20)
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .automatic, prompt: "Search...")
            .navigationTitle("Explore")
        }
        .onAppear {
            Task {
                let _ = await gamesViewModel.fetchGames()
                //            gamesViewModel.fetchRecommendations()
            }
        }
    }
}


#Preview {
    ExploreGamesView()
}
