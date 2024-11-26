//
//  Review.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

/// Represents review
struct Review: Codable, Identifiable {
    private(set) var id: UUID = .init()
    let createdAt: Date
    let updatedAt: Date
    let review: String
    let rating: Int
    var author: Author
    let gameID: UUID
    var likes: Int
    var dislikes: Int
    let commentsIDs: [UUID]
    
    // when its created
    init(review: String, rating: Int, gameID: UUID, author: Author) {
        self.id = .init()
        self.createdAt = Date()
        self.updatedAt = Date()
        self.review = review
        self.rating = rating
        self.gameID = gameID
        self.commentsIDs = []
        self.author = author
        self.dislikes = 0
        self.likes = 0
    }
    
    // when its updated
    init(oldReview: Review) {
        self.createdAt = oldReview.createdAt
        self.id = oldReview.id
        self.commentsIDs = oldReview.commentsIDs
        self.rating = oldReview.rating
        self.updatedAt = Date()
        self.gameID = oldReview.gameID
        self.review = oldReview.review
        self.author = oldReview.author
        self.likes = oldReview.likes
        self.dislikes = oldReview.dislikes
    }
}
