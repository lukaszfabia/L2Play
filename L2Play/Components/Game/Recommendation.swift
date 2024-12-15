//
//  Recommendation.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct GameRecommendationView: View {
    let game: GameWithState
    let w: CGFloat = 150
    let h: CGFloat = 220
    let scale: CGFloat = 1.75
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GameCover(cover: game.pic, w: 250*4/3, h: h*scale)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(game.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                HStack (spacing: 5) {
                    Text(game.studio)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                    
                    Text("|")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    Text(game.state == .notPlayed ? "Not played" : game.state.rawValue)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Text(game.description)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .frame(maxWidth: 250)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.95)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(15)
        }
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding()
    }
    
}
