//
//  ReviewCard.swift
//  L2Play
//
//  Created by Lukasz Fabia on 20/10/2024.


import SwiftUI

let RATING_RANGE: Int = 5

private struct ReviewRow<ReactionBar: View, CommentSection: View, AddComment: View>: View {
    @EnvironmentObject private var provider: AuthViewModel
    let isPresentedCommentsView: Bool
    var deleteReview: () -> Void
    var reload: () async -> Void
    @Binding var review: Review
    
    @ViewBuilder var reactionBar: () -> ReactionBar
    @ViewBuilder var addComment: () -> AddComment
    @ViewBuilder var commentSection: () -> CommentSection
    
    @State private var isNavigationActive: Bool = false
    
    let user: User?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                UserImage(pic: review.author.profilePicture)
                
                Divider()
                
                // TODO: fix navigation to user
                VStack(alignment: .leading) {
                    
                    //                    NavigationLink(destination: UserView(user: user)) {
                    Text(review.author.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    //                    }
                    
                    
                    HStack {
                        if review.updatedAt != review.createdAt {
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(.secondary)
                            Text(review.updatedAt.timeAgoSinceDate())
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        } else {
                            Text(review.createdAt.timeAgoSinceDate())
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                Menu {
                    // if review belongs to current user, he edit it
                    if provider.user.email == review.author.email {
                        Button(role: .destructive, action: {
                            deleteReview()
                            Task {
                                await reload()
                            }
                            
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        Button(action: { /*editReview()*/ }) {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                    Button(action: { /* share review*/ }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .padding()
                }
            }
            
            HStack {
                Text("\(review.rating)")
                    .font(.title)
                +
                Text("/\(RATING_RANGE)")
                    .foregroundStyle(.secondary)
                Image(systemName: "star.fill")
            }
            
            if !review.review.isEmpty {
                Text(review.review)
                    .padding(.top, 2)
            }
            
            if !review.oldReviews.isEmpty && isPresentedCommentsView {
                oldReviewsView(for: review.oldReviews)
            }
            
            Divider()
                .padding(.vertical, 5)
            
            HStack(spacing: 6) {
                reactionBar()
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 20)
            
            VStack(spacing: 10) {
                addComment()
                commentSection()
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    
    // MARK: - helper views
    
    @ViewBuilder
    private func oldReviewsView(for oldReviews: [OldReview]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(oldReviews.reversed(), id: \.id) { old in
                HStack(spacing: 15) {
                    VStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.accentColor)
                        Rectangle()
                            .frame(width: 2, height: 40)
                            .foregroundColor(.accentColor)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text(old.createdAt.timeAgoSinceDate())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 5) {
                            Text("\(old.rating)")
                                .fontWeight(.bold)
                            Text("/\(RATING_RANGE)")
                                .foregroundStyle(.gray)
                            Image(systemName: "star")
                        }
                        Text(old.review)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .padding(.top, 2)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                }
                .id(old.id)
            }
        }
        .padding(.top, 10)
    }
}



private struct ReactionBar: View {
    @StateObject var reviewViewModel: ReviewViewModel
    @Binding var isPresentedCommentsView: Bool
    
    var body: some View {
        HStack{
            Button(action: {
                if !isPresentedCommentsView {
                    isPresentedCommentsView.toggle()
                    HapticManager.shared.generateHapticFeedback(style: .light)
                }
            }) {
                Image(systemName: "message")
                Text("\(reviewViewModel.commentsCount.shorterNumber())")
            }
            
            Spacer()
            
            Button(action: {
                Task{
                    await reviewViewModel.like()
                    HapticManager.shared.generateHapticFeedback(style: .light)
                }
            }) {
                Image(systemName: reviewViewModel.hasUserReacted(for: \.likes) ? "heart.fill" : "heart")
                Text("\(reviewViewModel.review.likes.count.shorterNumber())")
            }
            
            Button(action:  {Task{
                await reviewViewModel.dislike()
                HapticManager.shared.generateHapticFeedback(style: .light)
            }}) {
                Image(systemName: reviewViewModel.hasUserReacted(for: \.dislikes) ?  "hand.thumbsdown.fill" : "hand.thumbsdown")
                if reviewViewModel.review.dislikes.count == 0 {
                    Text("0")
                } else {
                    Text("-\(reviewViewModel.review.dislikes.count.shorterNumber())")
                }
            }
        }
    }
}

struct ReviewCard: View {
    @StateObject var reviewViewModel: ReviewViewModel
    @StateObject private var userViewModel: UserViewModel
    @State private var isPresentedCommentsView = false
    @State private var comment: String = ""
    
    var reloadGame: () async -> Void

      init(reviewViewModel: ReviewViewModel, reloadGame: @escaping @Sendable () async -> Void) {
          _reviewViewModel = StateObject(wrappedValue: reviewViewModel)
          _userViewModel = StateObject(wrappedValue: UserViewModel())
          self.reloadGame = reloadGame
      }
    
    var body: some View {
        ReviewRow(
            isPresentedCommentsView: isPresentedCommentsView,
            deleteReview: reviewViewModel.deleteReview,
            reload: reloadGame,
            review: $reviewViewModel.review,
            reactionBar: {
                ReactionBar(reviewViewModel: reviewViewModel, isPresentedCommentsView: $isPresentedCommentsView)
            },
            addComment: {},
            commentSection: {},
            user: userViewModel.user
        )
        .cornerRadius(15)
        .sheet(isPresented: $isPresentedCommentsView) {
            NavigationStack {
                ScrollView {
                    ReviewRow(
                        isPresentedCommentsView: isPresentedCommentsView,
                        deleteReview: reviewViewModel.deleteReview,
                        reload: reloadGame,
                        review: $reviewViewModel.review,
                        reactionBar: {
                            ReactionBar(reviewViewModel: reviewViewModel, isPresentedCommentsView: $isPresentedCommentsView)
                        },
                        addComment: {
                            AddCommentView(comment: $comment) {
                                reviewViewModel.addComment(comment)
                            }
                        },
                        commentSection: {
                            ForEach(reviewViewModel.comments) { comment in
                                CommentRow(comment: comment)
                            }
                        },
                        user: userViewModel.user
                    )
                }
                .onAppear() {
                    Task {
                        await reviewViewModel.fetchComments()
                    }
                }
                .navigationTitle("\(String(describing: reviewViewModel.review.author.name.takeFirstWord()))'s review")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            isPresentedCommentsView = false
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                if let user = await userViewModel.fetchUserByEmail(reviewViewModel.review.author.email) {
                    self.userViewModel.user = user
                }
            }
        }
    }
}




private struct AddCommentView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @Binding var comment: String
    var onSubmit: () async -> Void
    
    @State private var isSubmitting = false
    
    var body: some View {
        HStack {
            UserImage(pic: provider.user.profilePicture, w: 45, h: 45)
            
            TextField("Add a comment...", text: $comment)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, 8)
                .disabled(isSubmitting)
            
            Button(action: {
                HapticManager.shared.generateHapticFeedback(style: .light)
                Task {
                    isSubmitting = true
                    await onSubmit()
                    comment = ""
                    isSubmitting = false
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .padding(10)
                    .background(Circle().fill(Color.accentColor))
                    .foregroundColor(.white)
            }
            .disabled(comment.isEmpty || isSubmitting)
        }
    }
}


struct CommentRow: View {
    let comment: Comment
    @State private var commenter: User? = nil
    
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    
    var body: some View {
        HStack(spacing: 6) {
            UserImage(pic: comment.author.profilePicture, w: 40, h: 40)
            
            VStack(alignment: .leading) {
                //                NavigationLink(destination: UserView(user: commenter), label: {
                Text(comment.author.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                //                })
                
                Text(comment.createdAt.timeAgoSinceDate())
                    .foregroundStyle(.gray)
                    .font(.caption)
                
                Text(comment.comment)
                    .foregroundStyle(.primary)
            }
            .padding()
            
            Spacer()
        }.onAppear() {
            Task {
                commenter = await userViewModel.fetchUserByEmail(comment.author.email)
            }
        }
    }
}
