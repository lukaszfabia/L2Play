//
//  Review.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

struct OldReview: Codable, Identifiable {
    var id: UUID
    let createdAt: Date
    let review: String
    let rating: Int
    
    init(createdAt: Date, review: String, rating: Int) {
        self.id = .init()
        self.createdAt = createdAt
        self.review = review
        self.rating = rating
    }
    
    init(review: Review) {
        self.id = review.id
        self.createdAt = review.createdAt
        self.review = review.review
        self.rating = review.rating
    }
}

class Review: Codable, Identifiable {
    var id: UUID
    let createdAt: Date
    var updatedAt: Date
    var review: String
    var oldReviews: [OldReview]
    var rating: Int
    var author: Author
    let gameID: UUID
    var likes: [String]
    var dislikes: [String]
    var commentsIDs: [String]

    // MARK: - Initializers
    init(review: String, rating: Int, gameID: UUID, author: Author) {
        self.id = UUID()
        self.createdAt = Date()
        self.updatedAt = Date()
        self.review = review
        self.oldReviews = []
        self.rating = rating
        self.gameID = gameID
        self.author = author
        self.likes = []
        self.dislikes = []
        self.commentsIDs = []
    }
    
    convenience init(user: User, gameID: UUID) {
        self.init(review: "", rating: 0, gameID: gameID, author: Author(user: user))
    }
    
    // MARK: - Methods
    
    func updateReview(newReview: String, newRating: Int) {
        self.oldReviews.append(OldReview(review: self))
        self.review = newReview
        self.rating = newRating
        
        self.updatedAt = Date()
    }

    func like(by userID: String) {
        if !likes.contains(userID) {
            likes.append(userID)
            dislikes.removeAll { $0 == userID }
        }
    }

    func dislike(by userID: String) {
        if !dislikes.contains(userID) {
            dislikes.append(userID)
            likes.removeAll { $0 == userID }
        }
    }

    func isLiked(by userID: String) -> Bool {
        return likes.contains(userID)
    }

    func isDisliked(by userID: String) -> Bool {
        return dislikes.contains(userID)
    }
    
    func updateAuthor(_ newAuthor: Author) -> Review {
        self.author = newAuthor
        return self
    }
    
}
