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
    @Binding var review: Review?
    
    @ViewBuilder var reactionBar: () -> ReactionBar
    @ViewBuilder var addComment: () -> AddComment
    @ViewBuilder var commentSection: () -> CommentSection
    
    var body: some View {
        if let review = review {
            VStack(alignment: .leading) {
                HStack {
                    UserImage(pic: review.author.profilePicture)
                    
                    Divider()
                    
                    // TODO: fix navigation to user 
                    NavigationLink(destination: EmptyView()) {
//                    NavigationLink(destination: userDestinationView(for: review)) {
                        VStack(alignment: .leading) {
                            Text(review.author.name)
                                .font(.headline)
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
                    }
                    .foregroundStyle(.primary)

                    
                    Spacer()
                    
                    Menu {
                        Button(role: .destructive, action: { deleteReview() }) {
                            Label("Delete", systemImage: "trash")
                        }
                        Button(action: { /*editReview()*/ }) {
                            Label("Edit", systemImage: "pencil")
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
    }
    
    // MARK: - helper views
    
    @ViewBuilder
    private func userDestinationView(for review: Review) -> some View {
        if provider.user.email == review.author.email {
            UserView()
        } else {
            ReadOnlyUserView(email: review.author.email)
        }
    }

    
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
    let review: Review
    
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
                reviewViewModel.like()
                HapticManager.shared.generateHapticFeedback(style: .light)
            }) {
                Image(systemName: reviewViewModel.hasUserReacted(for: \.likes) ? "heart.fill" : "heart")
                Text("\(review.likes.count.shorterNumber())")
            }
            
            Button(action: {
                reviewViewModel.dislike()
                HapticManager.shared.generateHapticFeedback(style: .light)
            }) {
                Image(systemName: reviewViewModel.hasUserReacted(for: \.dislikes) ?  "hand.thumbsdown.fill" : "hand.thumbsdown")
                if review.dislikes.count == 0 {
                    Text("0")
                } else {
                    Text("-\(review.dislikes.count.shorterNumber())")
                }
            }
        }
    }
}

struct ReviewCard: View {
    @StateObject var reviewViewModel: ReviewViewModel
    @State private var isPresentedCommentsView = false
    
    var body: some View {
        if let review = reviewViewModel.review {
            ReviewRow(
                isPresentedCommentsView: isPresentedCommentsView,
                deleteReview: reviewViewModel.deleteReview,
                review: $reviewViewModel.review,
                reactionBar: {
                    ReactionBar(reviewViewModel: reviewViewModel, isPresentedCommentsView: $isPresentedCommentsView, review: review)
                },
                addComment: {},
                commentSection: {}
            )
            .cornerRadius(15)
            .sheet(isPresented: $isPresentedCommentsView) {
                NavigationStack {
                    ScrollView {
                        ReviewRow(
                            isPresentedCommentsView: isPresentedCommentsView,
                            deleteReview: reviewViewModel.deleteReview,
                            review: $reviewViewModel.review,
                            reactionBar: {
                                ReactionBar(reviewViewModel: reviewViewModel, isPresentedCommentsView: $isPresentedCommentsView, review: review)
                            },
                            addComment: {
                                AddCommentView(reviewViewModel: reviewViewModel)
                            },
                            commentSection: {
                                ForEach(reviewViewModel.comments) { comment in
                                    CommentRow(comment: comment)
                                }
                            }
                        )
                    }
                    .navigationTitle("\(String(describing: review.author.name.takeFirstWord()))'s review")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                isPresentedCommentsView = false
                            }
                        }
                    }
                }
            }

        }
    }
}


private struct AddCommentView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var comment: String = ""
    @StateObject var reviewViewModel: ReviewViewModel
    
    var body: some View {
        HStack {
            UserImage(pic: provider.user.profilePicture , w: 45, h: 45)
            
            CustomFieldWithIcon(acc: $comment, placeholder: "Comment...", isSecure: false)
                .frame(maxWidth: .infinity)
                .textInputAutocapitalization(.sentences)
            
            Button(action: {
                Task {
                    HapticManager.shared.generateHapticFeedback(style: .light)
                    await reviewViewModel.addComment(comment)
                    comment = ""
                }
            }) {
                HStack {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
                .padding()
                .background(Color.accentColor)
                .clipShape(Circle())
            }
        }
    }
}

struct CommentRow: View {
    let comment: Comment
    
    var body: some View {
        HStack(spacing: 6) {
            UserImage(pic: comment.author.profilePicture, w: 40, h: 40)
            
            VStack(alignment: .leading) {
                Text(comment.author.name)
                    .font(.headline)
                
                Text(comment.createdAt.timeAgoSinceDate())
                    .foregroundStyle(.gray)
                    .font(.caption)
                
                Text(comment.comment)
                    .foregroundStyle(.primary)
            }
            .padding()
            
            Spacer()
        }
    }
}
