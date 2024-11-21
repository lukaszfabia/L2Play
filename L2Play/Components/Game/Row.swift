//
//  Row.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct GameRow: View {
    var game: Game
    
    var body: some View {
        NavigationLink(destination: GameView(game: game)) {
            VStack {
                HStack(spacing: 20) {
                    ZStack(alignment: .topLeading) {
                        GameCover(cover: game.pictures[0])
                        
                        HStack (spacing: 1) {
                            Text("#").font(.subheadline)
                                .fontWeight(.light)
                            Text("\(game.popularity)")
                        }.font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.7))
                            .clipShape(CustomCorners(cornerRadii: 15, corners: [.topLeft, .bottomRight]))
                        
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 4) {
                            Text(game.community.shorterNumber())
                                .font(.headline)
                                .bold()
                        }
                        
                        Text(game.name)
                            .font(.title2)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Text(game.studio)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        
                        RatingComponent(rating: game.rating, reviewsAmount: 34)
                    }
                    .padding(.vertical, 8)
                    
                    Spacer()
                }
            }
        }
        .foregroundStyle(Color.primary)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
        .shadow(radius: 4)
    }
}

struct FavoriteGamesRow: View {
    @State var game: Game
    
    var body: some View {
        NavigationLink(destination: GameView(game: game)) {
            VStack {
                HStack(spacing: 20) {
                    GameCover(cover: game.pictures[0])
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack (spacing: 10) {
                            RatingComponent(rating: game.rating)
                            
                        }.padding(.bottom, 5)
                        
                        Text(game.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        HStack(spacing: 5) {
                            Text(game.studio)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if let y = game.releaseYear {
                                Text("|").foregroundStyle(.secondary).font(.subheadline)
                                Text("\(y, specifier: "%d")")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .foregroundStyle(Color.primary)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .frame(maxWidth: .infinity)
    }
}
