//
//  LazyPostVIew.swift
//  L2Play
//
//  Created by Lukasz Fabia on 11/12/2024.
//


import SwiftUI

struct LazyPostView: View {
    @Binding var post: Post
    @Binding var posts: [Post]
    @ObservedObject var postViewModel: PostViewModel
    @ObservedObject var provider: AuthViewModel
    
    @State private var reposts: [Post] = []

    var body: some View {
        Group {
            if !postViewModel.isLoading {
                PostDetailsView(post: $post, posts: $posts, postViewModel: postViewModel, provider: provider, reposts: $reposts)
            } else {
                ProgressView("Loading post")
                    .task {
                        reposts = await postViewModel.fetchReposts(post)
                    }
            }
        }
    }
}

