//
//  ReviewViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import Foundation

class ReviewViewModel: ObservableObject {
    @Published private var user: User
    @Published private var game: Game
    @Published private var errorMessage: String = ""
    @Published var review: Review? = nil // potential users review
    @Published var comments: [Comment] = []
    
    
    private var manager = FirebaseManager()
    
    init(user: User, game: Game, review: Review) {
        self.user = user
        self.game = game
        self.review = review
        
        Task {
            await fetchComments()
        }
    }
    
    var commentsCount: Int {
        return comments.count
    }
    
    
    init(user: User, game: Game) {
        self.user = user
        self.game = game
    }
    
    private func toggleReaction(removeKeyPath: WritableKeyPath<Review, [UUID]>, addKeyPath: WritableKeyPath<Review, [UUID]>, review: inout Review) -> Review {
        if let index = review[keyPath: addKeyPath].firstIndex(of: user.id) {
            review[keyPath: addKeyPath].remove(at: index)
        } else {
            review[keyPath: removeKeyPath].removeAll { $0 == user.id }
            review[keyPath: addKeyPath].append(user.id)
        }
        
        return review
    }
    
    private func updateReactState(r: Review) {
        Task {
            do {
                try await manager.update(collection: .reviews, id: r.id.uuidString, object: r)
            } catch {
                print("Failed to react")
            }
        }
        
        DispatchQueue.main.async{
            self.review = r
        }
    }
    
    func like() {
        guard var r = review else { return }
        r = toggleReaction(removeKeyPath: \.dislikes, addKeyPath: \.likes, review: &r)
        updateReactState(r: r)
    }
    
    func dislike() {
        guard var r = review else { return }
        r = toggleReaction(removeKeyPath: \.likes, addKeyPath: \.dislikes, review: &r)
        updateReactState(r: r)
    }
    
    
    func hasUserReacted(for keyPath: WritableKeyPath<Review, [UUID]>) -> Bool {
        guard let r = review else { return false }
        
        return r[keyPath: keyPath].contains(user.id)
    }
    
    func deleteReview() {
        if let r = review {
            self.manager.delete(collection: .reviews, id: r.id.uuidString){ res in
                switch res {
                case .failure:
                    self.errorMessage = "Failed to remove review"
                case .success:
                    self.review = nil
                }
            }
        }
    }
    
    @MainActor
    func addReview(content: String, rating: Int) async {
        var reviews: [Review] = []
        
        do {
            let fetchedRes: [Review] = try await manager.findAll(collection: .reviews, whereIs: ("gameID", game.id.uuidString))
            reviews = fetchedRes
        } catch let err {
            
            self.errorMessage = err.localizedDescription
            
            return
        }
        
        let userReview = reviews.filter { $0.author.email == user.email }
        
        if !userReview.isEmpty {
            // just update
            let old = userReview.first!
            
            let updatedReview = Review(oldReview: old, newReview: content, newRating: rating)
            
            do {
                try await manager.update(collection: .reviews, id: old.id.uuidString, object: updatedReview)
                
                
                self.review = updatedReview
                
            } catch let err {
                
                self.errorMessage = err.localizedDescription
                
                return
            }
        } else {
            let newReview = Review(review: content, rating: rating, gameID: game.id, author: Author(user: user))
            do {
                let res: Review = try await manager.create(collection: .reviews, object: newReview, customID: newReview.id.uuidString)
                
                
                self.review = res
                
            } catch let err {
                
                self.errorMessage = err.localizedDescription
                
                
                return
            }
        }
    }
    
    @MainActor
    func fetchComments() async {
        guard let r = review else { return }
        do {
            let comments : [Comment] = try await manager.findAll(collection: .comments, whereIs: ("reviewID", r.id.uuidString))
            
            self.comments = comments
        } catch {
            return
        }
    }
    
    @MainActor
    func addComment(_ comment: String) async {
        guard let r = review else { return } // does not exits so cant add elo
        
        do  {
            let newComment = Comment(reviewID: r.id, comment: comment, author: Author(user: user))
            
            let _ = try manager.create(collection: .comments, object: newComment)
            
            comments.append(newComment)
        } catch let err {
            self.errorMessage = "Failed to add comment"
            print("Failed to add comment: \(err.localizedDescription)")
        }
        
    }
}
