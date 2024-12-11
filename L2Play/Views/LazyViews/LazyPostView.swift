//
//  LazyPostVIew.swift
//  L2Play
//
//  Created by Lukasz Fabia on 11/12/2024.
//


import SwiftUI

struct LazyPostView: View {
    @Binding var post: Post
    @ObservedObject var postViewModel: PostViewModel
    @ObservedObject var provider: AuthViewModel
    
    @State private var reposts: [Post] = []
    
    var body: some View {
        Group {
            if !reposts.isEmpty || post.reposts.isEmpty {
                PostDetailsView(post: $post, postViewModel: postViewModel, provider: provider, reposts: $reposts)
            } else {
                LoadingView()
            }
        }.task {
            // dont fetch 
            if !post.reposts.isEmpty {
                reposts = await postViewModel.fetchReposts(post)
            }
        }
    }
}

