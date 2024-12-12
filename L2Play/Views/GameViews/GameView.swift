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
    @State private var selectedState: GameState = .notPlayed
    @State private var fav: Bool = false
    
    @State private var triedToFetch: Bool = false
    
    var body: some View {
        if gameViewModel.reviews.isEmpty && !triedToFetch {
            LoadingView().task {
                selectedState = provider.user.getCurrentGameState(where: gameViewModel.game.id)
                await gameViewModel.fetchReviewsForGame()
                
                triedToFetch.toggle()
            }
        }
        else if triedToFetch {
            Game()
                .refreshable {
                    triedToFetch.toggle()
                    await gameViewModel.refreshGame()
                    await provider.refreshUser(provider.user)
                }
                .sheet(isPresented: $isPresentedReviewForm) {
                    NavigationStack {
                        ReviewForm(
                            gv: gameViewModel,
                            closeForm: $isPresentedReviewForm
                        )
                        .navigationTitle("Create Review")
                        .navigationBarTitleDisplayMode(.inline)
                        .onDisappear {
                            Task {
                                await gameViewModel.refreshGame()
                            }
                        }
                    }
                }
                .navigationTitle("Game")
        }
    }
    
    private func Game() -> some View {
        ScrollView {
            GalleryView(images: gameViewModel.game.pictures)
                .padding(.top)
            
            Spacer(minLength: 20)
            
            gameHeaderView
            
            statePicker
            
            Spacer(minLength: 40)
            
            BentoBoxView(game: gameViewModel.game)
            
            Spacer(minLength: 40)
            
            writeReviewButton
            
            if !gameViewModel.reviews.isEmpty {
                VStack {
                    ForEach(gameViewModel.reviews) { review in
                        ReviewView(
                            reviewViewModel: ReviewViewModel(user: provider.user, game: gameViewModel.game, review: review),
                            refreshGame: gameViewModel.refreshGame
                        )
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
            }
        }
    }
    
    private var gameHeaderView: some View {
        VStack(alignment: .center) {
            Text(gameViewModel.game.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            HStack {
                Text(gameViewModel.game.releaseYear)
                    .foregroundStyle(.gray)
                
                Text(gameViewModel.game.studio)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal)
    }
    
    private var statePicker: some View {
        VStack {
            Picker("State", selection: $selectedState) {
                ForEach(GameState.allCases.prefix(GameState.allCases.count / 2)) { state in
                    Text(state.rawValue.capitalized).tag(state)
                }
            }
            .pickerStyle(.segmented)
            
            Picker("State", selection: $selectedState) {
                ForEach(GameState.allCases.suffix(GameState.allCases.count / 2)) { state in
                    Text(state.rawValue.capitalized).tag(state)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal)
        .onChange(of: selectedState) { updateGameState(selectedState) }
    }

    
    private var writeReviewButton: some View {
        Button(action: { isPresentedReviewForm.toggle() }) {
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
    }
    
    private func updateGameState(_ newState: GameState) {
        Task {
            await gameViewModel.addGame(state: newState)
            await MainActor.run {
                withAnimation {
                    selectedState = newState
                }
            }
            
            await provider.refreshUser(provider.user)
            
            HapticManager.shared.generateHapticFeedback(style: .light)
        }
    }
}
