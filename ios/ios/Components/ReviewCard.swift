//
//  ReviewCard.swift
//  ios
//
//  Created by Lukasz Fabia on 20/10/2024.
//

import SwiftUI

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
                        Text(review.author.firstName)
                            .font(.headline)
                        Text(review.author.lastName)
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundStyle(.gray)
                    }
                    
                    Text(timeAgoSinceDateSimple(review.createdAt))
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
            }
            
            HStack {
                Text("\(review.rating)")
                    .font(.title)
                +
                Text("/10")
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
            
            Divider().padding(5)
            
            children()
        }
        .padding()
        .background(.primary.opacity(0.1))
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
            HStack {
                
                TextField("Comment review...", text: $comment)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(12)
                
            }
            .background(.primary.opacity(0.1))
            .cornerRadius(15)
            
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
                .background(.indigo)
                .clipShape(Circle())
            }
            .padding()
        }
    }
}

struct CommentRow: View {
    let comment : Comment
    
    var body: some View {
        HStack (spacing: 6){
            AsyncImage(url: comment.author.profilePicture) { image in
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
            
            VStack(alignment: .leading) {
                HStack{
                    Text(comment.author.firstName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(comment.author.lastName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(timeAgoSinceDateSimple(comment.createdAt))
                    .foregroundStyle(.gray)
                    .font(.caption)
                
                Text(comment.comment)
            }
        }
    }
}

struct CommentsView: View {
    let review: Review
    
    var body: some View {
        VStack {
            ScrollView {
                ReviewRow(review: review) {
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
    }
}


#Preview {
    ReviewCard(review: Review.dummy())
}
