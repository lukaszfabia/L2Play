//
//  Row.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct GameRow: View {
    var gameViewModel: GameViewModel
    
    var body: some View {
        NavigationLink(destination: GameView(gameViewModel: gameViewModel)) {
            VStack {
                HStack(spacing: 20) {
                    ZStack(alignment: .topLeading) {
                        GameCover(cover: gameViewModel.game.pictures[0])
                        
                        HStack (spacing: 1) {
                            Text("#").font(.subheadline)
                                .fontWeight(.light)
                            Text("\(gameViewModel.game.popularity)")
                        }.font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.7))
                            .clipShape(CustomCorners(cornerRadii: 15, corners: [.topLeft, .bottomRight]))
                        
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 4) {
                            Text(gameViewModel.game.community.shorterNumber())
                                .font(.headline)
                                .bold()
                        }
                        
                        Text(gameViewModel.game.name)
                            .font(.title2)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Text(gameViewModel.game.studio)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        
                        RatingComponent(rating: gameViewModel.game.rating, reviewsAmount: 34)
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
    var gameViewModel: GameViewModel
    
    var body: some View {
        NavigationLink(destination: GameView(gameViewModel: gameViewModel)) {
            VStack {
                HStack(spacing: 20) {
                    GameCover(cover: gameViewModel.game.pictures[0])
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack (spacing: 10) {
                            RatingComponent(rating: gameViewModel.game.rating)
                            
                        }.padding(.bottom, 5)
                        
                        Text(gameViewModel.game.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        HStack(spacing: 5) {
                            Text(gameViewModel.game.studio)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if let y = gameViewModel.game.releaseYear {
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
