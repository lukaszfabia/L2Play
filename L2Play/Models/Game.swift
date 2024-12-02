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
    var popularity: Int
    var community: Int
    let releaseYear: Int?
    var rating: Double
    let platform: [String]
    let multiplayerSupport: Bool
    let price: Double?
    
    func getYear() -> String {
        return "\(String(describing: releaseYear))"
    }
    
    
    static func dummy() -> Game {
        return Game(name: "", studio: "", tags: [], pictures: [], description: "", popularity: 0, community: 0, releaseYear: 1970, rating: 0.0, platform: [], multiplayerSupport: false, price: nil)
    }
}
