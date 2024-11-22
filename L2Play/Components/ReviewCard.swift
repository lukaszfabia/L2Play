//
//  ReviewCard.swift
//  ios
//
//  Created by Lukasz Fabia on 20/10/2024.
//

import SwiftUI

let RATING_RANGE: Int = 5

struct ReviewRow<Children: View>: View {
    let review: Review
    let children: () -> Children
    
    @ViewBuilder var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: review.author.profilePicture) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .shadow(radius: 12)
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(review.author.firstName ?? "unknown")
                            .font(.headline)
                        Text(review.author.lastName ?? "user")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundStyle(.gray)
                    }
                    
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
                
                Image(systemName: "star")
            }
            
            VStack {
                Text(review.review)
            }
            .padding(.top, 5)
            
            Divider().padding(5).background(.clear)
            HStack (spacing: 6){
                Image(systemName: "message")
                Text("12")
                
                Spacer()
                
                Image(systemName: "heart")
                Text("12")
                
                Image(systemName: "arrow.down")
                Text("12")
                
            }.padding(.horizontal, 5)
            
            Spacer().padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                children()
            }
        }
        .padding()
    }
}


struct ReviewCard: View {
    let review: Review
    @State private var isPresentedCommentsView = false
    
    var body: some View {
        ReviewRow(review: review) {
            Button(action: {
                isPresentedCommentsView.toggle()
            }) {
                // there is nothing
            }
            .padding(.horizontal, 40)
        }
        .cornerRadius(15)
        .onTapGesture {
            isPresentedCommentsView.toggle()
        }
        .sheet(isPresented: $isPresentedCommentsView) {
            CommentsView(review: review)
        }
    }
}


struct AddCommentView: View {
    @State private var comment: String = ""
    let review : Review
    
    var body:some View {
        HStack{
            UserImage(pic: review.author.profilePicture, w: 45, h: 45)
            
            CustomFieldWithIcon(acc: $comment, placeholder: "Comment...", icon: "pencil", isSecure: false).frame(maxWidth: .infinity)
            
            
            Button(action: {
                print("submit comment: \(comment)")
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
    let comment : Comment
    
    var body: some View {
        HStack (spacing: 6){
            NavigationLink(destination: UserView(user: comment.author)) {
                UserImage(pic: comment.author.profilePicture, w: 50, h: 50)
            }
            VStack(alignment: .leading) {
                HStack{
                    Text(comment.author.firstName ?? "unknown")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(comment.author.lastName ?? "user")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(comment.createdAt.timeAgoSinceDate())
                    .foregroundStyle(.gray)
                    .font(.caption)
                
                Text(comment.comment)
                    .foregroundStyle(.primary)
            }.padding()
            
            Spacer()
        }
    }
}

struct CommentsView: View {
    let review: Review
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    ReviewRow(review: review){
                        VStack(spacing: 10) {
                            AddCommentView(review: review)
                            ForEach(review.comments, id: \.id) { comment in
                                CommentRow(comment: comment)
                                    .id(comment.id)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("\(String(describing: review.author.firstName))'s review")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



#Preview {
    ReviewCard(review: Review.dummy())
}
