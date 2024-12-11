//
//  PostViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 11/12/2024.
//

import Foundation
import SwiftUI

@MainActor
class PostViewModel: ObservableObject, AsyncOperationHandler {
    private let _manager = FirebaseManager()
    
    @Published var errorMessage: String? = ""
    
    @Published var isLoading: Bool = false
    
    @Published var user: User // session user
    @Published var posts: [Post] = []
    @Published var reposts: [Post] = [] // comments for given posts


    init(user: User) {
        self.user = user
    }
    
    func post(_ post : Post, image: UIImage?) async -> Post? {
        if let image {
            do {
                let url = try await CloudinaryService.shared.uploadImage(image: image)
                post.image = url
            } catch {
                print("Failed to update photo")
            }
        }
        
        let r: Result<Post, Error> = await performAsyncOperation {[self] in
             try await _manager.create(collection: .posts, object: post, customID: post.id.uuidString)
        }
        
        return (try? r.get()) ?? nil
    }
    
    func repost(_ repost: Post, image: UIImage?, post: Post) async -> Post? {
        let newRepost = await self.post(repost, image: image)
        
        guard let newRepost else {return nil}
        
        post.reposts.append(newRepost.id)
        
        _ = await performAsyncOperation{ [self] in
            try await _manager.update(collection: .posts, id: post.id.uuidString, object: post)
        }
        
        return newRepost
    }
    
    func fetchPosts() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        // lets display current session user posts and following ppl posts
        let targetIds: [String] = user.following + [user.id]
        
        let r : Result<[Post], Error> = await performAsyncOperation { [self] in
            // get all posts from observed ppl
            try await self._manager.findAll(collection: .posts, ids: targetIds, in: "author.id")
        }
        
        if case .success(let success) = r {
            self.posts = success
                .filter{!$0.isRepost}
                .sorted(by: {$0.createdAt > $1.createdAt})
            
        } else if case .failure(let failure) = r {
            print(failure.localizedDescription)
        }
    }
    
    func fetchReposts(_ currPost: Post) async -> [Post] {
        self.isLoading = true
        defer { self.isLoading = false }
        
        let r : Result<[Post], Error> = await performAsyncOperation { [self] in
            try await self._manager.findAll(collection: .posts, ids: currPost.reposts.map({$0.uuidString}))
        }
        
        return (try? r.get()) ?? []
    }
    
    func deletePost(_ post: Post) async {
        guard post.author.id == user.id else {return}
        
        if !post.reposts.isEmpty {
            _ = await performAsyncOperation { [self] in
                // remove all assocciated reposts with post
                try await self._manager.delete(collection: .posts, ids: post.reposts)
            }
        }
        
        self._manager.delete(collection: .posts, id: post.id.uuidString)
    }
    
    func postReact(_ post: Post) async {
         _ = await performAsyncOperation {
            try await self._manager.update(collection: .posts, id: post.id.uuidString, object: post)
        }
    }
}
