//
//  Comment.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

/// Represents comment
class Comment: Codable, Identifiable {
    private(set) var id: UUID = .init()
    private let reviewID: UUID
    let createdAt: Date
    let comment: String
    var author: Author
    
    
    init(reviewID: UUID, comment: String, author: Author) {
        self.reviewID = reviewID
        self.createdAt = Date()
        self.comment = comment
        self.author = author
    }
    
    func updateAuthor(_ newAuthor: Author) -> Comment {
        self.author = newAuthor
        return self
    }
}
