//
//  Recommendation.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct GameRecommendationView: View {
    let game: Game
    let w: CGFloat = 150
    let h: CGFloat = 220
    let scale: CGFloat = 1.75

    var body: some View {
            ZStack(alignment: .bottom) {
                GameCover(cover: game.pictures[0], w: 250*4/3, h: h*scale)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        RatingComponent(rating: game.rating, font: .headline)
                        
                        
                        Text(game.community.shorterNumber())
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                    }
                    
                    Text(game.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack (spacing: 5) {
                        Text(game.studio)
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        if let year = game.releaseYear {
                            Text("|")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            
                            Text(String(year))
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
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
