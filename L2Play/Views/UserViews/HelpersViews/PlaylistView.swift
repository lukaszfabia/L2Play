//
//  PlaylistView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 14/12/2024.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var userViewModel: UserViewModel
    let collection : [Collection]
    
    var body: some View {
        ScrollView {
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
            .navigationTitle("Playlist")
        }
    }
}
