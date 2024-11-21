//
//  Review.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

struct Review: Codable, Identifiable {
    private(set) var id: UUID = .init()
    let createdAt: Date
    let review: String
    let rating: Int
    let author: User
    let comments: [Comment]
    
    static func dummy() -> Review {
        return Review(id: UUID(), createdAt: Date(), review: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio velit, accumsan id erat sed, faucibus tristique lectus. Sed condimentum libero scelerisque tincidunt scelerisque. Nulla venenatis tellus id erat mollis, eget cursus lorem dignissim. Sed luctus hendrerit nisi id molestie. Integer enim lorem, lacinia a dignissim sit amet, ullamcorper et nunc.", rating: 8, author: User.dummy(), comments: [Comment.dummy(),Comment.dummy(),Comment.dummy(),Comment.dummy()])
    }
}
