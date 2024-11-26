//
//  Comment.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

/// Represents comment
struct Comment: Codable, Identifiable {
    private(set) var id: UUID = .init()
    private let reviewID: UUID
    let createdAt: Date
    let comment: String
    let author: Author
    
    
    init(id: UUID, reviewID: UUID, comment: String, author: Author) {
        self.id = id
        self.reviewID = reviewID
        self.createdAt = Date()
        self.comment = comment
        self.author = author
    }
}
