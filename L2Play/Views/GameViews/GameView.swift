//
//  GameView.swift
//  ios
//
//  Created by Lukasz Fabia on 19/10/2024.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject var gameViewModel: GameViewModel
    @State private var isPresentedReviewForm: Bool = false
    @State private var onlist: Bool = false
    @State private var fav: Bool = false
    
    var body: some View {
        Game()
            .refreshable {
                await gameViewModel.refreshGame()
                await provider.refreshUser(provider.user)
            }
            .sheet(isPresented: $isPresentedReviewForm) {
                NavigationStack {
                    ReviewForm(
                        reviewViewModel: ReviewViewModel(user: provider.user, game: gameViewModel.game),
                        updateGameRating: gameViewModel.updateGameRating,
                        closeForm: $isPresentedReviewForm
                    )
                    .navigationTitle("Create Review")
                    .navigationBarTitleDisplayMode(.inline)
                    .onDisappear {
                        Task {
                            await gameViewModel.fetchReviewsForGame()
                        }
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
            .navigationTitle("Game")

    }
    
    private func Game() -> some View {
        ScrollView {
            
            GalleryView(images: gameViewModel.game.pictures)
                .padding(.top)
            
            Spacer(minLength: 20)
            
            
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
                Button(action: toggleGameState) {
                    Image(systemName: onlist ? "checkmark" : "plus")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(onlist ? Color.green.gradient : Color.accentColor.gradient)
                        .clipShape(Circle())
                        .shadow(
                            color: onlist ? .green.opacity(0.4) : .accentColor.opacity(0.4),
                            radius: 5, x: 0, y: 5
                        )
                }
                
                Divider()
                
                Button(action: toggleFavState) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(fav ? .red : .white)
                        .padding()
                        .background(fav ? Color.white.gradient : Color.red.gradient)
                        .clipShape(Circle())
                        .shadow(color: fav ? .white.opacity(0.4) : .red.opacity(0.4), radius: 5, x: 0, y: 5)
                }
            }
            
            Spacer(minLength: 40)
            
            BentoBoxView(game: gameViewModel.game)
            
            Spacer(minLength: 40)
            
            Button(action: {
                isPresentedReviewForm.toggle()
            }) {
                Text("Write review")
                    .font(.headline)
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
                        ReviewCard(reviewViewModel: ReviewViewModel(user: provider.user, game: gameViewModel.game, review: review), reloadGame: gameViewModel.refreshGame).id(review.id)
                    }
                }
                .padding()
            }
        }
    }
    
    private func toggleGameState() {
        Task {
            await gameViewModel.toggleGameState()
            await MainActor.run {
                withAnimation {
                    onlist = gameViewModel.isOnList()
                }
            }
            HapticManager.shared.generateHapticFeedback(style: .light)
        }
    }
    
    private func toggleFavState() {
        Task {
            await gameViewModel.toogleFavGameState()
            await MainActor.run {
                withAnimation {
                    fav = gameViewModel.isFav()
                }
            }
            HapticManager.shared.generateHapticFeedback(style: .light)
        }
    }
}
