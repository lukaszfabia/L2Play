//  ReviewShowcase.swift
//  L2Play
//
//  Created by Lukasz Fabia on 02/12/2024.
//

import SwiftUI

struct ReviewShowcase: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    
    @StateObject private var gameViewModel: GameViewModel
    
    init(reviewViewModel: ReviewViewModel) {
        self.reviewViewModel = reviewViewModel
        self._gameViewModel = StateObject(wrappedValue: GameViewModel(game: reviewViewModel.game, user: reviewViewModel.user))
    }
    
    var body: some View {
        Group {
            if reviewViewModel.isLoading {
                LoadingView()
            }else {
                VStack(alignment: .leading, spacing: 10) {
                    headerView
                    ratingView
                    reviewTextView
                    oldReviewsView(for: reviewViewModel.review.oldReviews)
                    reactionBarView
                }
                .frame(maxWidth: .infinity)
            }
        }.task {
            await reviewViewModel.fetchComments()
        }
    }


    private var headerView: some View {
        HStack(spacing: 10) {
            UserImage(pic: reviewViewModel.review.author.profilePicture)
            VStack(alignment: .leading) {
                NavigationLink(destination: LazyGameView(gameID: reviewViewModel.review.gameID, userViewModel: UserViewModel(user: reviewViewModel.user))) {
                    Text(reviewViewModel.review.author.name)
                        .font(.headline)
                }
                .buttonStyle(PlainButtonStyle())
                timestampView
            }
            Spacer()
            MenuWithActions(reviewViewModel: reviewViewModel, gameViewModel: gameViewModel)
        }
    }


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


    private var ratingView: some View {
        HStack {
            Text("\(reviewViewModel.review.rating)")
                .font(.title) +
            Text("/\(RATING_RANGE)")
                .foregroundStyle(.secondary)
            Image(systemName: "star.fill")
        }
    }

 
    private var reviewTextView: some View {
        Text(reviewViewModel.review.review)
            .padding(.top, 5)
            .font(.body)
            .foregroundColor(.primary)
    }


    private var reactionBarView: some View {
        ReactionBar(
            reviewViewModel: reviewViewModel,
            userViewModel: UserViewModel(user: reviewViewModel.user),
            gameViewModel: gameViewModel
        )
    }
}
