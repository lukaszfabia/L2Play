//
//  Comment.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

struct Comment: Codable, Identifiable {
    private(set) var id: UUID = .init()
    let createdAt: Date
    let comment: String
    let author: User
    
    static func dummy() -> Comment {
        let url: URL = URL(string: "https://placebeard.it/250/250")!
        return Comment(id: UUID(), createdAt: Date(), comment: "test test tes test testtestss", author: User(
            firstName: "Joe",
            lastName: "Doe",
            email: "joe.doe@example.com",
            avatar: url
        ))
    }
}
