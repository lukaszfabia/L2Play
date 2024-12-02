//
//  ReviewViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import Foundation

@MainActor
class ReviewViewModel: ObservableObject, AsyncOperationHandler {
    @Published var errorMessage: String? = ""
    
    @Published var isLoading: Bool = false
    
    @Published var user: User // session user 
    @Published var game: Game
    @Published var review: Review
    @Published var comments: [Comment] = []
    
    
    private var manager = FirebaseManager()
    
    init(user: User, game: Game, review: Review) {
        self.user = user
        self.game = game
        self.review = review
    }
    
    init(user: User, game: Game) {
        self.user = user
        self.game = game
        
        // potential reveiew for current user
        self.review = Review(review: "", rating: 0, gameID: game.id, author: Author(user: user))
    }
    
    // please fetch game
    init(user: User, review: Review){
        self.user = user
        self.review = review
        
        self.game = Game.dummy()
    }
    
    
    var commentsCount: Int {
        return comments.count
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
    
    private func updateReactState(r: Review) async {
        let result: Result<_, Error> = await performAsyncOperation {
            try await self.manager.update(collection: .reviews, id: r.id.uuidString, object: r)
        }
        
        switch result {
        case .success:
            self.review = r
        case .failure(let error):
            print("Failed to update review: \(error.localizedDescription)")
            self.errorMessage = "Failed to updat review"
        }
    }
    
    func like() async {
        review = toggleReaction(removeKeyPath: \.dislikes, addKeyPath: \.likes, review: &review)
        await updateReactState(r: review)
    }
    
    func dislike() async {
        review = toggleReaction(removeKeyPath: \.likes, addKeyPath: \.dislikes, review: &review)
        await updateReactState(r: review)
    }
    
    
    func hasUserReacted(for keyPath: WritableKeyPath<Review, [UUID]>) -> Bool {
        return review[keyPath: keyPath].contains(user.id)
    }
    
    func deleteReview() {
        self.manager.delete(collection: .reviews, id: review.id.uuidString)
    }
    
    func addReview(content: String, rating: Int) async {
        var reviews: [Review] = []
        // fetch reviews for a game
        let result: Result<[Review], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .reviews, whereIs: ("gameID", self.game.id.uuidString))
        }
        
        switch result {
        case .success(let fetchedReviews):
            reviews = fetchedReviews
        case .failure(let error):
            print("Failed to fetch reviews: \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch reviews"
            return
        }
        
        let userReview = reviews.first {$0.author.email == user.email}
        
        if let userReview {
            let old = userReview
            
            
            let updatedReview = Review(oldReview: old, newReview: content, newRating: rating)
            
            let updateResult: Result<_, Error> = await performAsyncOperation {
                try await self.manager.update(collection: .reviews, id: old.id.uuidString, object: updatedReview)
            }
            
            switch updateResult {
            case .success:
                self.review = updatedReview
            case .failure(let error):
                print("Failed to update review: \(error.localizedDescription)")
                self.errorMessage = "Failed to update review"
            }
            
        } else {
            
            let newReview = Review(review: content, rating: rating, gameID: game.id, author: Author(user: user))
            
            
            let createResult: Result<Review, Error> = await performAsyncOperation {
                try await self.manager.create(collection: .reviews, object: newReview, customID: newReview.id.uuidString)
            }
            
            switch createResult {
            case .success(let fetchedReview):
                self.review = fetchedReview
            case .failure(let error):
                print("Failed to create review: \(error.localizedDescription)")
                self.errorMessage = "Failed to create review"
            }
        }
    }
    
    
    func fetchComments() async {
        let result: Result<[Comment], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .comments, whereIs: ("reviewID", self.review.id.uuidString))
        }
        
        switch result {
        case .success(let fetchedComments):
            comments = fetchedComments
        case .failure(let error):
            print("Failed to fetch comments: \(error.localizedDescription)")
            errorMessage = "Failed to fetch comments"
        }
    }
    
    func addComment(_ comment: String) {
        do {
            let c = try manager.create(
                collection: .comments,
                object: Comment(reviewID: review.id, comment: comment, author: Author(user: user))
            )
            
            if let index = comments.firstIndex(where: { $0.createdAt < c.createdAt }) {
                comments.insert(c, at: index)
            } else {
                comments.append(c)
            }
            
        } catch let err {
            print("Failed to add comment: \(err.localizedDescription)")
            self.errorMessage = "Failed to add comment"
        }
    }
    
    
    func reportReview(reason: ReportReason) {
        self.isLoading = true
        defer { self.isLoading = false }
        
        let newReport = ReportedReview(whoReported: user.id, reason: reason, reviewID: review.id)
        
        do {
            let _ = try self.manager.create(collection: .reported_reviews, object: newReport)
        } catch {
            self.errorMessage = "Failed to report review"
        }
    }
    
    func fetchGameByID() async -> Game? {
        let r: Result<Game, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .games, id: self.review.gameID.uuidString)
        }
        
        switch r {
        case .success(let fetchedGame):
            return fetchedGame
        case .failure:
            return nil
        }
    }
}
