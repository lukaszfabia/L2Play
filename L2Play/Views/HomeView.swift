//
//  HomeView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/12/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var postcreator = false
    @State private var selectedGame: GameWithState?
    @State private var posts: [Post] = []
    @StateObject var postViewModel: PostViewModel

    
    var body: some View {
        if postViewModel.isLoading {
            LoadingView().task {
                await loadPosts()
            }
        } else {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        welcome
                        
                        postSection
                    }.padding(.horizontal, 10)
                }
                .padding(.horizontal, 5)
                .navigationTitle("Welcome, \(provider.user.firstName ?? "")!")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { postcreator.toggle() }) {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                        }
                    }
                }
                .sheet(isPresented: $postcreator) {
                    PostForm(postViewModel: postViewModel, posts: $posts, postcreator: $postcreator)
                }
            }
            .refreshable {
                await loadPosts()
            }
        }
    }
    
    private func loadPosts() async {
        guard !postViewModel.isLoading else {return}
        await postViewModel.fetchPosts()
        self.posts = postViewModel.posts
    }
    
    private var welcome: some View {
        VStack(alignment: .leading) {
            
            Text("Here are you daily recommendations!")
                .font(.headline.bold())
            
            Text("Check out what's happening in your world of games!")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            
            //            CustomPageSlider
        }
        .padding(.bottom, 15)
    }
    
    private var postSection: some View {
        VStack(alignment: .leading) {
            CustomDivider()
            
            ForEach($posts, id: \.id) { $post in
                VStack(alignment: .leading, spacing: 10) {
                    profile(post: $post, posts: $posts, postViewModel: postViewModel, provider: provider)
                    
                    postInfo(post: $post, posts: $posts, postViewModel: postViewModel, provider: provider)
                    
                    reactionBar(post: $post, posts: $posts, postViewModel: postViewModel, provider: provider)
                }
                .padding(.bottom, 15)
                
                CustomDivider()
            }
        }

    }
    
}


struct PostForm: View {
    @State private var title: String = ""
    @State private var content: String = ""
    
    @EnvironmentObject private var provider: AuthViewModel
    @ObservedObject var postViewModel: PostViewModel
    
    @State private var isSubmitting: Bool = false
    @Binding var posts: [Post]
    @Binding var postcreator: Bool
    
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                UserImage(pic: provider.user.profilePicture)
                
                VStack(alignment: .leading) {
                    Text(provider.user.fullName())
                        .font(.headline)
                    Text("now")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Text("Title")
                .font(.footnote)
                .foregroundStyle(.gray)
            
            CustomFieldWithIcon(acc: $title, placeholder: "What do you think about?")
                .textInputAutocapitalization(.sentences)
                .padding(.vertical, 5)
            
            
            Text("Content")
                .font(.footnote)
                .foregroundStyle(.gray)
            
            TextEditor(text: $content)
                .padding(4)
                .frame(height: 150)
                .font(.body)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .textInputAutocapitalization(.sentences)
                .padding(.vertical, 3)
            
            Text("Append media for post!")
                .foregroundStyle(.gray)
                .font(.footnote)
            
            Button(action: {
                showImagePicker.toggle()
            }) {
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                            )
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            
            Spacer()
            
            Button(action: submitPost) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(content.isEmpty || isSubmitting ? Color.gray : Color.accentColor)
                        .frame(height: 50)

                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.white)
                    } else {
                        Text("Post")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .disabled(content.isEmpty || isSubmitting)
            .padding(.bottom, 20)

        }
        .padding()
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func submitPost() {
        guard !isSubmitting else { return }
        isSubmitting = true
        
        Task {
            let newPost = Post(
                title: title,
                content: content,
                author: Author(user: provider.user)
            )
            
            if let createdPost = await postViewModel.post(newPost, image: selectedImage) {
                posts.insert(createdPost, at: 0)
                HapticManager.shared.generateSuccessFeedback()
                title = ""
                content = ""
                selectedImage = nil
                postcreator = false
            } else {
                print("Failed to create post")
            }
            
            isSubmitting = false
        }
    }
}



struct PostDetailsView: View {
    @Binding var post: Post
    @Binding var posts: [Post]
    @ObservedObject var postViewModel: PostViewModel
    @ObservedObject var provider: AuthViewModel
    
    @Binding var reposts: [Post]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            profile(post: $post, posts: $posts, postViewModel: postViewModel, provider: provider)
            
            postInfo(post: $post, posts: $posts, postViewModel: postViewModel, provider: provider)
            
            reactionBar(post: $post, posts: $posts, postViewModel: postViewModel, provider: provider)
            
            
            // section with reposts
            ForEach($reposts) { $repost in
//                postInfo(post: $repost, posts: [], postViewModel: <#T##PostViewModel#>, provider: <#T##AuthViewModel#>)
            }
        }
        .padding(.bottom, 15)
    }
}

private struct profile: View {
    @Binding var post: Post
    @Binding var posts: [Post]
    @ObservedObject var postViewModel: PostViewModel
    @ObservedObject var provider: AuthViewModel
    
    var body: some View {
        HStack {
            NavigationLink(destination: LazyUserView(userID: post.author.id, userViewModel: UserViewModel())) {
                UserImage(pic: post.author.profilePicture)
            }
            
            VStack(alignment: .leading) {
                Text(post.author.name)
                    .font(.headline)
                Text(post.createdAt.timeAgoSinceDate())
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if provider.user.id == post.author.id {
                Menu {
                    Button(role: .destructive, action: {
                        Task {
                            await postViewModel.deletePost(post)
                            posts.removeAll { $0 == post }
                            HapticManager.shared.generateSuccessFeedback()
                        }
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .padding()
                }
            }
        }
    }
}


private struct postInfo: View {
    @Binding var post: Post
    @Binding var posts: [Post]
    @ObservedObject var postViewModel: PostViewModel
    @ObservedObject var provider: AuthViewModel
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title = post.title {
                Text(title)
                    .font(.title.bold())
            }
            
            Text(post.content)
                .font(.body)
            
            if let imageUrl = post.image {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
            }
        }
    }
}


private struct reactionBar: View {
    @Binding var post: Post
    @Binding var posts: [Post]
    @ObservedObject var postViewModel: PostViewModel
    @ObservedObject var provider: AuthViewModel
    
    var body: some View {
        HStack {
            NavigationLink(destination: LazyPostView(post: $post, posts: $posts, postViewModel: postViewModel, provider: provider)) {
                HStack {
                    Text("\(post.reposts.count)")
                        .foregroundStyle(Color.accentColor)
                    
                    Image(systemName: "message")
                        .foregroundColor(.accentColor)
                }
            
            }
            .onTapGesture {
                HapticManager.shared.generateSuccessFeedback()
            }
            .buttonStyle(PlainButtonStyle())
            
            
            Spacer()
            
            Button(action: {
                post.toggleVoteForYes(provider.user.id)
                updatePost(post: post)
            }) {
                HStack {
                    Text("\(post.ups)")
                        .foregroundStyle(Color.accentColor)
                    
                    Image(systemName: post.userVotedYes(provider.user.id) ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(.accentColor)
                }
            }
            
            Button(action: {
                post.toggleVoteForNo(provider.user.id)
                updatePost(post: post)
            }) {
                HStack {
                    Text("\(post.downs == 0 ? "" : "-")\(post.downs)")
                        .foregroundStyle(.red)
                    
                    Image(systemName: post.userVotedNo(provider.user.id) ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private func updatePost(post: Post) {
        if let index = posts.firstIndex(where: { $0 == post}) {
            posts[index] = post
        }
        
        Task {
            await postViewModel.postReact(post)
        }
        
        DispatchQueue.main.async {
            if provider.errorMessage == nil {
                HapticManager.shared.generateSuccessFeedback()
            } else {
                HapticManager.shared.generateErrorFeedback()
            }
        }
    }
}