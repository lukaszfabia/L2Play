//
//  GameView.swift
//  ios
//
//  Created by Lukasz Fabia on 19/10/2024.
//

import SwiftUI

struct GameView: View {
    let generator = UIImpactFeedbackGenerator(style: .light)
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject var gameViewModel: GameViewModel
    @State private var isPresentedReviewForm: Bool = false
    @State private var onlist: Bool = false
    @State private var fav: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                /// main image
                GalleryView(images: gameViewModel.game.pictures)
                    .padding(.top)
                
                Spacer(minLength: 20)
                
                /// Game title and rating
                VStack(alignment: .center) {
                    Text(gameViewModel.game.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    HStack {
                        if let year = gameViewModel.game.releaseYear {
                            Text(String(year))
                                .foregroundStyle(.gray)
                        }
                        Text(gameViewModel.game.studio)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation {
                            gameViewModel.toggleGameState(refreshUser: provider.refreshUser)
                            onlist = gameViewModel.isOnList()
                        }
                        generator.prepare()
                        generator.impactOccurred()
                    }) {
                        Image(systemName: onlist ? "checkmark" : "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(onlist ? Color.green.gradient : Color.accentColor.gradient)
                            .clipShape(Circle())
                            .shadow(
                                color: onlist
                                ? .green.opacity(0.4)
                                : .accentColor.opacity(0.4),
                                radius: 5, x: 0, y: 5
                            )
                    }
                    
                    Divider()
                    
                    Button(action: {
                        withAnimation(){
                            gameViewModel.toogleFavGameState(refreshUser: provider.refreshUser)
                            fav = gameViewModel.isFav()
                        }
                        generator.prepare()
                        generator.impactOccurred()
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20))
                            .foregroundColor(fav ? .red : .white)
                            .padding()
                            .background(fav ? Color.white.gradient: Color.red.gradient)
                            .clipShape(Circle())
                            .shadow(color: fav ? .white.opacity(0.4) : .red.opacity(0.4), radius: 5, x: 0, y: 5)
                    }
                }
                
                Spacer(minLength: 40)
                
                BentoBoxView(game: gameViewModel.game)
                
                Spacer(minLength: 40)
                
                /// form to rate game or write review
                Button(action: {
                    isPresentedReviewForm.toggle()
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "doc.text")
                            .resizable()
                            .frame(width: 17, height: 17)
                        
                        Text("Write review")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.primary, lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                
                if !gameViewModel.reviews.isEmpty {
                    LazyVStack {
                        ForEach(gameViewModel.reviews) { review in
                            ReviewCard(reviewViewModel: ReviewViewModel(user: provider.user, game: gameViewModel.game, review: review)).id(review.id)
                        }
                    }
                    .padding()
                }
            }
        }
        
        .sheet(isPresented: $isPresentedReviewForm) {
            ReviewForm(reviewViewModel: ReviewViewModel(user: provider.user, game: gameViewModel.game), closeForm: $isPresentedReviewForm)
                .onDisappear {
                    Task {
                        await gameViewModel.fetchReviewsForGame()
                    }
                }
        }
        .onAppear {
            onlist = gameViewModel.isOnList()
            fav = gameViewModel.isFav()
            
            Task {
                await gameViewModel.fetchReviewsForGame()
            }
        }
        .refreshable {
            await gameViewModel.refreshGame()
            await provider.refreshUser(provider.user)
        }
        .navigationTitle("Game")
    }
}
