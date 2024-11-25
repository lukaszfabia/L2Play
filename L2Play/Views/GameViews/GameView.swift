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
    @State var isPresentedReviewForm: Bool = false
    @State private var onlist: Bool = false
    
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
                        print("Favorite tapped")
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 5)
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
                
                if !gameViewModel.game.reviews.isEmpty {
                    VStack {
                        //                        ForEach(gameViewModel.game.reviews) { review in
                        //                            ReviewCard(review: review)
                        //                        }
                    }
                    .padding()
                }
            }
        }
        
        .sheet(isPresented: $isPresentedReviewForm) {
            ReviewForm()
        }
        .onAppear {
            onlist = gameViewModel.isOnList()
        }
        .refreshable {
            await gameViewModel.refreshGame()
            await provider.refreshUser(provider.user)
        }
        .navigationTitle("Game")
    }
}
