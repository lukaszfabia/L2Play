//
//  ExploreGamesView.swift
//  ios
//
//  Created by Lukasz Fabia on 27/10/2024.
//

import SwiftUI

// TODO: optionally we can add some filters to search easier

struct ExploreGamesView: View {
    @State private var searchText: String = ""
    private let games = [Game.dummy(), Game.dummy(), Game.dummy()]
    
    // TODO: find out how to handle translations
    
    @State private var items: [Item] = [
        .init(color: .blue, title: "Ready for the Rift?", subTitle: "Dive into epic 5v5 battles and prove your dominance.", game: Game.dummy()),
        .init(color: .blue, title: "SwiftUI Mastery", subTitle: "Learn how to build iOS apps.", game: Game.dummy()),
        .init(color: .green, title: "Healthy Living", subTitle: "Tips for a balanced lifestyle.", game: Game.dummy()),
        .init(color: .orange, title: "Travel Tips", subTitle: "Make your journey unforgettable.", game: Game.dummy()),
        .init(color: .purple, title: "Gaming Guide", subTitle: "Level up your skills.", game: Game.dummy()),
        .init(color: .pink, title: "Creative Ideas", subTitle: "Unlock your inner artist.", game: Game.dummy()),
    ]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                        Text("Recommendations for You")
                            .fontWeight(.light)
                            .font(.title)
                            .padding(.horizontal)
                    
                            Text("Swipe to see more")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                            
                    
                    
                    CustomPageSlider(data: $items) { $item in
                        NavigationLink(destination: GameView(game: item.game)){
                            GameRecommendationView(game: item.game)
                        }
                    } titleContent: { $item in
                        VStack(spacing:10) {
                            Text(item.title)
                                .font(.title.bold())
                            Text(item.subTitle)
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(height: 45)
                                .padding(.bottom, 5)
                        }.padding(.bottom, 5)
                    }
                    .safeAreaPadding([.horizontal, .top, .bottom], 35)



                    VStack(alignment: .leading) {
                        HStack {
                            Text("Currently Popular")
                                .fontWeight(.light)
                                .font(.title)
                            Image(systemName: "arrow.up.right")
                                .font(.title)
    
                        }
                        .padding(.horizontal)
                        Text("Swipe to see more")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(games, id: \.id) { game in
                                GameRow(game: game)
                            }
                        }
                        .safeAreaPadding([.horizontal, .top], 20)
                    }
                }
            }
            .searchable(text: $searchText, placement: .automatic, prompt: "Search...")
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreGamesView()
}
