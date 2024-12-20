//
//  ReviewView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 01/12/2024.
//

import SwiftUI
let RATING_RANGE: Int = 5

struct ReactionBar: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    
    var body: some View {
        HStack{
            NavigationLink(destination: ReviewViewDetails(reviewViewModel: reviewViewModel, userViewModel: userViewModel, gameViewModel: gameViewModel), label: {
                Image(systemName: "message")
                Text("\(reviewViewModel.commentsCount.shorterNumber())")
            }).buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Button(action: {
                Task{
                    await reviewViewModel.like()
                    HapticManager.shared.generateHapticFeedback(style: .light)
                }
            }) {
                Image(systemName: reviewViewModel.review.isLiked(by: reviewViewModel.user.id) ? "heart.fill" : "heart")
                Text("\(reviewViewModel.review.likes.count.shorterNumber())")
            }
            
            Button(action:  {Task{
                await reviewViewModel.dislike()
                HapticManager.shared.generateHapticFeedback(style: .light)
            }}) {
                Image(systemName: reviewViewModel.review.isDisliked(by: reviewViewModel.user.id) ?  "hand.thumbsdown.fill" : "hand.thumbsdown")
                if reviewViewModel.review.dislikes.count == 0 {
                    Text("0")
                } else {
                    Text("-\(reviewViewModel.review.dislikes.count.shorterNumber())")
                }
            }
        }
    }
}

struct MenuWithActions: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    @State private var selectedReason: ReportReason? = nil
    @State private var isPresented: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Menu {
            if reviewViewModel.user.id == reviewViewModel.review.author.id {
                Button(role: .destructive, action: {
                    reviewViewModel.deleteReview()
                    Task {
                        await gameViewModel.updateGameRating()
                        dismiss() // back to previous view
                        await gameViewModel.refreshGame()
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                }
            } else {
                Button(role: .destructive, action: {
                    isPresented = true
                }) {
                    Label("Report", systemImage: "exclamationmark.triangle")
                }
            }
            
            Button(action: {
                // share review action
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.title3)
                .foregroundColor(.primary)
                .padding()
        }
        .sheet(isPresented: $isPresented) {
            VStack {
                Text("Select the reason for reporting:")
                    .font(.headline)
                    .padding()
                
                Picker("Reason", selection: $selectedReason) {
                    ForEach(reportReasons, id: \.self) { reason in
                        Text(reason.rawValue).tag(reason as ReportReason?)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                
                Button(action: {
                    if let reason = selectedReason {
                        reportReview(reason: reason)
                        isPresented = false
                    }
                }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                        
                        Text("Report")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedReason == nil ? Color.gray : Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .disabled(selectedReason == nil)
                
            }
            .padding()
        }
    }
    
    private func reportReview(reason: ReportReason) {
        reviewViewModel.reportReview(reason: reason)
        
        if reviewViewModel.errorMessage != nil {
            HapticManager.shared.generateErrorFeedback()
        } else {
            HapticManager.shared.generateSuccessFeedback()
        }
    }
}


struct AddCommentView: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    @State private var comment: String = ""
    @State private var isSubmitting = false
    
    var body: some View {
        HStack {
            if let avatar = reviewViewModel.user.profilePicture {
                UserImage(pic: avatar, initial: reviewViewModel.user.fullName(), w: 45, h: 45)
            }
            
            TextField("Add a comment...", text: $comment)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, 8)
                .disabled(isSubmitting)
            
            Button(action: {
                HapticManager.shared.generateHapticFeedback(style: .light)
                isSubmitting = true
                reviewViewModel.addComment(comment)
                comment = ""
                isSubmitting = false
                
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

func oldReviewsView(for oldReviews: [OldReview]) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(Array(oldReviews.reversed()).indices, id: \.self) { index in
            let old = oldReviews.reversed()[index]
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


struct ReviewViewDetails: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        Group {
            if reviewViewModel.isLoading || userViewModel.isLoading {
                LoadingView()
            } else {
                detailedView
            }
        }.task {
            await reviewViewModel.fetchComments()
            await userViewModel.fetchUser(with: reviewViewModel.review.author.id)
        }
    }
    
    private var detailedView: some View {
        VStack {
            ScrollView {
                ReviewRow(reviewViewModel: reviewViewModel, userViewModel: userViewModel, gameViewModel: gameViewModel, isDetail: true)
                
                if let u = userViewModel.user, !u.hasBlocked(reviewViewModel.user.id){
                    AddCommentView(reviewViewModel: reviewViewModel)
                }
                
                ForEach(reviewViewModel.comments) { comment in
                    CommentRow(comment: comment)
                }
            }
        }
        .padding(.top, 20)
        .padding()
        .navigationTitle("Review Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommentRow: View {
    let comment: Comment
    
    var body: some View {
        HStack(spacing: 6) {
            UserImage(pic: comment.author.profilePicture, initial: comment.author.name, w: 40, h: 40)
            
            VStack(alignment: .leading) {
                NavigationLink(destination: LazyUserView(userID: comment.author.id, userViewModel: UserViewModel()), label: {
                    Text(comment.author.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }).buttonStyle(PlainButtonStyle())
                
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


struct ReviewRow: View {
    @ObservedObject var reviewViewModel: ReviewViewModel
    @ObservedObject var userViewModel: UserViewModel // author
    @ObservedObject var gameViewModel: GameViewModel // author
    
    var isDetail: Bool = false
    
    private func headerWithReviewer() -> some View {
        HStack (spacing: 10) {
            UserImage(pic:
                    reviewViewModel.review.author.profilePicture,
                    initial: reviewViewModel.review.author.name
            )
            
            VStack (alignment: .leading) {
                NavigationLink(destination: UserView(user: userViewModel.user), label: {
                    Text(reviewViewModel.review.author.name)
                })
                .buttonStyle(PlainButtonStyle())
                
                HStack (spacing: 5){
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
            
            Spacer()
            
            // disable reaction bar when author has blocked current user
            if let u = userViewModel.user, !u.hasBlocked(reviewViewModel.user.id) {
                MenuWithActions(reviewViewModel: reviewViewModel, gameViewModel: gameViewModel)
            }
        }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            headerWithReviewer()
            
            HStack {
                Text("\(reviewViewModel.review.rating)")
                    .font(.title)
                +
                Text("/\(RATING_RANGE)")
                    .foregroundStyle(.secondary)
                Image(systemName: "star.fill")
            }
            
            if !reviewViewModel.review.review.isEmpty {
                if !isDetail {
                    NavigationLink(destination: ReviewViewDetails(reviewViewModel: reviewViewModel, userViewModel: userViewModel, gameViewModel: gameViewModel)) {
                        Text(reviewViewModel.review.review)
                            .padding(.top, 2)
                    }.buttonStyle(PlainButtonStyle())
                } else {
                    Text(reviewViewModel.review.review)
                        .padding(.top, 2)
                }
                
                if !reviewViewModel.review.oldReviews.isEmpty && isDetail {
                    oldReviewsView(for: reviewViewModel.review.oldReviews)
                }
            }
            
            if let u = userViewModel.user, !u.hasBlocked(reviewViewModel.user.id) {
                Divider()
                    .padding(.vertical, 5)
                
                HStack(spacing: 6) {
                    ReactionBar(reviewViewModel: reviewViewModel, userViewModel: userViewModel, gameViewModel: gameViewModel)
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 20)
            }
        }.padding(10)
    }
}

struct ReviewView: View {
    @ObservedObject var reviewViewModel: ReviewViewModel // we have curr-user/review/game
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    @ObservedObject var gameViewModel: GameViewModel
    
    
    var body: some View {
        Group {
            if userViewModel.isLoading || reviewViewModel.isLoading {
                LoadingView()
            } else {
                ReviewRow(reviewViewModel: reviewViewModel, userViewModel: userViewModel, gameViewModel: gameViewModel)
                    .padding(5)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .shadow(radius: 20)
            }
        }.task  {
            await reviewViewModel.fetchComments()
            await userViewModel.fetchUser(with: reviewViewModel.review.author.id)
        }
    }
}
