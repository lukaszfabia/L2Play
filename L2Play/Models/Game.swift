//
//  Game.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

struct Game: Codable, Identifiable {
    private(set) var id: UUID = .init()
    let name: String
    let studio : String
    let tags: [String]
    let pictures: [URL]
    let description : String
    let popularity: Int
    let community: Int
    let releaseYear: Int?
    let rating: Double
    let platform: [String]
    let multiplayerSupport: Bool
    let price: Double?
}
