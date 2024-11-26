//
//  ReviewCard.swift
//  ios
//
//  Created by Lukasz Fabia on 20/10/2024.


import SwiftUI

let RATING_RANGE: Int = 5

struct ReviewRow<ReactionBar: View, CommentSection: View, AddComment: View>: View {
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
                    
                    VStack(alignment: .leading) {
                        Text(review.author.name)
                            .font(.headline)
                        
                        Text(review.createdAt.timeAgoSinceDate())
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                }
                
                
                HStack {
                    Text("\(review.rating)")
                        .font(.title)
                    +
                    Text("/\(RATING_RANGE)")
                        .foregroundStyle(.gray)
                    
                    Image(systemName: "star.fill")
                }
                
                
                if !review.review.isEmpty {
                    VStack {
                        Text(review.review)
                    }
                    .padding(.top, 5)
                }
                
                Divider()
                    .padding(.vertical, 5)
                    .background(.clear)
                
                HStack(spacing: 6) {
                    reactionBar()
                }
                .padding(.horizontal, 5)
                
                VStack(spacing: 10) {
                    addComment()
                    commentSection()
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

struct ReviewCard: View {
    private let generator = UIImpactFeedbackGenerator(style: .light)
    @StateObject var reviewViewModel: ReviewViewModel
    @State private var isPresentedCommentsView = false
    
    var body: some View {
        if let review = reviewViewModel.review {
            ReviewRow(
                review: $reviewViewModel.review,
                reactionBar: {
                    HStack {
                        Button(action: {
                            isPresentedCommentsView.toggle()
                            makeBrr()
                        }) {
                            Image(systemName: "message")
                            Text("\(review.commentsIDs.count.shorterNumber())")
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 
                            makeBrr()
                        }) {
                            Image(systemName: "heart")
                            Text("\(review.likes.shorterNumber())")
                        }
                        
                        Button(action: {
                            //
                            makeBrr()
                        }) {
                            Image(systemName: "hand.thumbsdown")
                            Text("\(review.dislikes.shorterNumber())")
                        }
                    }
                },
                addComment: {},
                commentSection: {}
            )
            .cornerRadius(15)
            .sheet(isPresented: $isPresentedCommentsView) {
                NavigationView {
                    ScrollView {
                        ReviewRow(
                            review: $reviewViewModel.review,
                            reactionBar: {
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "message")
                                        Text("\(review.commentsIDs.count.shorterNumber())")
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        //
                                        makeBrr()
                                    }) {
                                        Image(systemName: "heart")
                                        Text("\(review.likes.shorterNumber())")
                                    }
                                    
                                    Button(action: {
                                        //
                                        makeBrr()
                                    }) {
                                        Image(systemName: "hand.thumbsdown")
                                        Text("\(review.dislikes.shorterNumber())")
                                    }
                                }
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
    
    private func makeBrr(){
        generator.prepare()
        generator.impactOccurred()
    }
}


struct AddCommentView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var comment: String = ""
    @StateObject var reviewViewModel: ReviewViewModel
    
    var body: some View {
        HStack {
            UserImage(pic: provider.user.profilePicture , w: 45, h: 45)
            
            CustomFieldWithIcon(acc: $comment, placeholder: "Comment...", icon: "pencil", isSecure: false)
                .frame(maxWidth: .infinity)
                .textInputAutocapitalization(.sentences)
            
            Button(action: {
                print("Submit comment: \(comment)")
                comment = ""
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
            UserImage(pic: comment.author.profilePicture)
            
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
