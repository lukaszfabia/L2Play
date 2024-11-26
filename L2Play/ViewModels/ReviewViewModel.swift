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
    @Published var review: Review? = nil
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
    }
    
    
    
    func addLike() {
        
    }
    
    func addDislike() {
        
    }
    
    func addReview(content: String, rating: Int) async {
        var reviews: [Review] = []
        
        do {
            let fetchedRes: [Review] = try await manager.findAll(collection: .reviews, ids: [game.id])
            reviews = fetchedRes
        } catch let err {
            DispatchQueue.main.async {
                self.errorMessage = err.localizedDescription
            }
            return
        }
        
        let userReview = reviews.filter { $0.author.userID == user.id }
        
        if !userReview.isEmpty {
            // just update
            let old = userReview.first!
            
            let updatedReview = Review(oldReview: old)
            
            do {
                // TODO: fix it, create new reviews all time 
                try await manager.update(collection: .reviews, id: old.id.uuidString, object: updatedReview)
            } catch let err {
                DispatchQueue.main.async {
                    self.errorMessage = err.localizedDescription
                }
                return
            }
        } else {
            let newReview = Review(review: content, rating: rating, gameID: game.id, author: Author(user: user))
            do {
                let res: Review = try await manager.create(collection: .reviews, object: newReview, uniqueFields: ["game", "author"], uniqueValues: [game.id.uuidString, user.id.uuidString], customID: newReview.id.uuidString)
                
                
                DispatchQueue.main.async {
                    self.review = res
                }
            } catch let err {
                DispatchQueue.main.async {
                    self.errorMessage = err.localizedDescription
                }
                
                return
            }
        }
    }
    
    func addComment() {
        
    }
}
