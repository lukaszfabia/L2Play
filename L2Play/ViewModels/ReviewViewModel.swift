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
    
    var commentsCount: Int {
        return comments.count
    }
    
    
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
        self.review = Review(user: user, gameID: game.id)
    }
    
    // please fetch game
    init(user: User, review: Review){
        self.user = user
        self.review = review
        
        self.game = Game() // empty game
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
        review.like(by: user.id)
        await updateReactState(r: review)
    }
    
    func dislike() async {
        review.dislike(by: user.id)
        await updateReactState(r: review)
    }
    
    func deleteReview() {
        self.manager.delete(collection: .reviews, id: review.id.uuidString)
    }
    

    func fetchComments() async {
        let result: Result<[Comment], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .comments, whereIs: ("reviewID", self.review.id.uuidString))
        }
        
        switch result {
        case .success(let fetchedComments):
            self.comments = fetchedComments
            break
        case .failure:
            break
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
            _ = try self.manager.create(collection: .reported_reviews, object: newReport)
        } catch {
            self.errorMessage = "Failed to report review"
        }
    }
    
    func fetchGameByID() async -> Game? {
        self.isLoading = true
        defer { self.isLoading = false }
        
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
