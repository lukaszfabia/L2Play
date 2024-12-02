//  ReviewShowcase.swift
//  L2Play
//
//  Created by Lukasz Fabia on 02/12/2024.
//

import SwiftUI

struct ReviewShowcase: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    @State private var game: Game? = nil
    var refreshUser: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            CustomDivider()
            
            headerView
            
            ratingView
            
            reviewTextView
            
            oldReviewsView(for: reviewViewModel.review.oldReviews)
            
            reactionBarView
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cornerRadius(20)
        .onAppear {
            loadGameData()
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack(spacing: 10) {
            UserImage(pic: reviewViewModel.review.author.profilePicture)
            
            VStack(alignment: .leading) {
                NavigationLink(destination: GameView(gameViewModel: GameViewModel(game: game ?? reviewViewModel.game, user: reviewViewModel.user))) {
                    Text(reviewViewModel.review.author.name)
                        .font(.headline)
                }
                .buttonStyle(PlainButtonStyle())
                
                timestampView
            }
            
            Spacer()
            
            MenuWithActions(reviewViewModel: reviewViewModel, reload: refreshUser)
        }
    }

    // MARK: - Timestamp View
    private var timestampView: some View {
        HStack(spacing: 5) {
            if reviewViewModel.review.updatedAt != reviewViewModel.review.createdAt {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(.secondary)
                Text(reviewViewModel.review.updatedAt.timeAgoSinceDate())
                    .foregroundStyle(.secondary)
                    .font(.caption)
            } else {
                Text(reviewViewModel.review.createdAt.timeAgoSinceDate())
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }

    // MARK: - Rating View
    private var ratingView: some View {
        HStack {
            Text("\(reviewViewModel.review.rating)")
                .font(.title)
            +
            Text("/\(RATING_RANGE)")
                .foregroundStyle(.secondary)
            Image(systemName: "star.fill")
        }
    }

    // MARK: - Review Text View
    private var reviewTextView: some View {
        Text(reviewViewModel.review.review)
            .padding(.top, 5)
            .font(.body)
            .foregroundColor(.primary)
    }

    // MARK: - Reaction Bar View
    private var reactionBarView: some View {
        ReactionBar(
            reviewViewModel: reviewViewModel,
            userViewModel: UserViewModel(user: reviewViewModel.user),
            refreshGame: { }
        )
    }

    // MARK: - Load Game Data
    private func loadGameData() {
        Task {
            game = await reviewViewModel.fetchGameByID()
            
            if let game {
                self.game = game
            }
        }
    }
}
