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
    
    init(id: UUID = UUID(), createdAt: Date, review: String, rating: Int) {
        self.id = id
        self.createdAt = createdAt
        self.review = review
        self.rating = rating
    }
}


/// Represents review
struct Review: Codable, Identifiable {
    private(set) var id: UUID = .init()
    let createdAt: Date
    let updatedAt: Date
    let review: String
    let oldReviews: [OldReview]
    let rating: Int
    var author: Author
    let gameID: UUID
    var likes: [UUID]
    var dislikes: [UUID]
    let commentsIDs: [UUID]
    
    // when its created
    init(review: String, rating: Int, gameID: UUID, author: Author) {
        self.id = .init()
        self.createdAt = Date()
        self.updatedAt = Date()
        self.review = review
        self.oldReviews = []
        self.rating = rating
        self.gameID = gameID
        self.commentsIDs = []
        self.author = author
        self.dislikes = []
        self.likes = []
    }
    
    // when its updated
    init(oldReview: Review, newReview: String, newRating: Int) {
        self.createdAt = oldReview.createdAt
        self.id = oldReview.id
        self.commentsIDs = oldReview.commentsIDs
        self.updatedAt = Date()
        self.gameID = oldReview.gameID
        self.author = oldReview.author
        self.likes = oldReview.likes
        self.dislikes = oldReview.dislikes
        
        let old = OldReview(createdAt: oldReview.updatedAt, review: oldReview.review, rating: oldReview.rating)
        
        self.oldReviews = oldReview.oldReviews + [old] 
        
        self.rating = newRating
        self.review = newReview
    }

}
