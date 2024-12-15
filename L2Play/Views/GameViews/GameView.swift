//
//  GameView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/37/2024.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject var gameViewModel: GameViewModel
    
    @State private var isPresentedReviewForm: Bool = false
    @State private var selectedState: GameState = .notPlayed
    
    
    var body: some View {
        Group {
            if gameViewModel.isLoading {
                LoadingView()
            } else {
                TabView {
                    GameContent()
                        .navigationTitle("Game")
                    
                    ReviewContent()
                        .sheet(isPresented: $isPresentedReviewForm) {
                            reviewBody
                        }
                        .navigationTitle("Reviews")
                }
                .safeAreaPadding(.vertical, 10)
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
        }
        .task {
            await fetchData()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var reviewBody: some View {
        NavigationStack {
            ReviewForm(
                gv: gameViewModel,
                closeForm: $isPresentedReviewForm
            )
            .navigationTitle("Create Review")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    private func fetchData() async {
        if gameViewModel.reviews.isEmpty {
            selectedState = provider.user.getCurrentGameState(where: gameViewModel.game.id)
            await gameViewModel.fetchReviewsForGame()
        }
    }
    
    private func ReviewContent() -> some View {
        ZStack {
            ScrollView {
                if !gameViewModel.reviews.isEmpty {
                    VStack(alignment: .leading) {
                        ForEach(gameViewModel.reviews, id: \.id) { review in
                            let reviewViewModel = ReviewViewModel(
                                user: provider.user,
                                game: gameViewModel.game,
                                review: review)
                            
                            ReviewView(
                                reviewViewModel: reviewViewModel,
                                gameViewModel: gameViewModel
                            )
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                } else {
                    VStack(alignment: .center, spacing: 16) {
                        Text("Be first!")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.accentColor)

                        Text("fellingsAboutGame".localized(with: gameViewModel.game.name))
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .padding([.horizontal, .vertical], 10)
                }
            }

            writeReviewButton
                .padding(10)
        }

    }
    
    private func GameContent() -> some View {
        ScrollView {
            GalleryView(images: gameViewModel.game.pictures)
                .padding(.top)
            
            Spacer(minLength: 20)
            
            gameHeaderView
            
            statePicker
            
            Spacer(minLength: 40)
            
            BentoBoxView(game: gameViewModel.game)
                .padding(.bottom, 20)
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
                
                Image(systemName: "circle.fill")
                    .foregroundStyle(.gray)
                    .font(.system(size: 5))

                
                Text(gameViewModel.game.studio)
                    .foregroundStyle(.gray)
            }
        }
        .padding([.horizontal, .vertical])
    }
    
    private var statePicker: some View {
        VStack {
            Picker("State", selection: $selectedState) {
                ForEach(GameState.allCases.prefix(GameState.allCases.count / 2)) { state in
                    Text(state == .notPlayed ? "Not played" : state.rawValue.capitalized).tag(state)
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
        .onChange(of: selectedState) {
            Task {
                await updateGameState(selectedState)
            }
        }
    }
    
    private var writeReviewButton: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 60, height: 60)
            
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.title)
        }
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(20)
        .onTapGesture {
            HapticManager.shared.generateHapticFeedback(style: .medium)
            isPresentedReviewForm.toggle()
        }
    }

    
    
    private func updateGameState(_ newState: GameState) async {
        await gameViewModel.addGame(state: newState)
        await MainActor.run {
            withAnimation {
                selectedState = newState
            }
        }
        HapticManager.shared.generateHapticFeedback(style: .light)
    }
}
