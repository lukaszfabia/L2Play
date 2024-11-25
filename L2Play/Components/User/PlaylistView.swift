//
//  PlaylistView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI

struct PlaylistView: View {
    @Binding var playlist: [Game]
    @EnvironmentObject var provider: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Playlist")
                    .font(.largeTitle)
                    .fontWeight(.light)
                
                if playlist.isEmpty {
                    Text("No games planned to play.")
                        .foregroundStyle(.secondary)
                }
                else {
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(playlist, id: \.id) { game in
                                
                                GameCard(gameViewModel: GameViewModel(game: game, user: provider.user))
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
    }
}
