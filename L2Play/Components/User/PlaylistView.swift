//
//  PlaylistView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI

import SwiftUI

private struct Collection: Identifiable {
    let id: UUID = .init()
    let games: [GameWithState]
    let title: String
    let subtitle: String
    let state: GameState
}

struct PlaylistView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    @State private var planned: [GameWithState] = []
    @State private var playing: [GameWithState] = []
    @State private var completed: [GameWithState] = []
    @State private var dropped: [GameWithState] = []
    
    @State private var collection: [Collection] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Text("Playlist")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .padding(.bottom)

                
                Image(systemName: "gamecontroller")
                    .font(.largeTitle)
                    .padding(.bottom)
            }

            
            ForEach(collection) { elem in
                VStack(alignment: .leading) {
                    if !elem.games.isEmpty {
                        NavigationLink(destination: GameList(state: elem.state, games: elem.games)) {
                            HStack {
                                Text(elem.title)
                                    .font(.title2.bold())
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())

                        
                        Text(elem.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(elem.games, id: \.id) { game in
                                    NavigationLink(destination: LazyGameView(gameID: game.gameID, userViewModel: userViewModel)) {
                                        GameCard(cover: game.pic)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            if let dict = userViewModel.user?.splitByState() {
                self.planned = dict[.planned] ?? []
                self.playing = dict[.playing] ?? []
                self.completed = dict[.completed] ?? []
                self.dropped = dict[.dropped] ?? []
            
                self.collection = [
                    Collection(games: self.planned, title: "Upcoming Adventures", subtitle: "Games you're excited to start.", state: .planned),
                    Collection(games: self.playing, title: "Current Quests", subtitle: "Games you're immersed in right now.", state: .playing),
                    Collection(games: self.completed, title: "Victorious Journeys", subtitle: "Games you've conquered.", state: .completed),
                    Collection(games: self.dropped, title: "Paused Dreams", subtitle: "Games you've set aside for now.", state: .dropped)
                ]
            }
        }

    }
}
