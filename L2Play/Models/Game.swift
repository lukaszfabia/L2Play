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
    let tags: [Tag]
    let pictures: [URL]
    let description : String
    let popularity: Int
    let community: Int
    let reviews: [UUID]
    let releaseYear: Int?
    let rating: Double
    let platform: [String]
    let multiplayerSupport: Bool
    let price: Double?
    let developers: [String]?
    
    static func dummy() -> Game {
        return Game(
            name: "League of Legends",
            studio: "Riot Games",
            tags: [Tag(id: UUID(), name: "Action"), Tag(id: UUID(), name: "Adventure"), Tag(id: UUID(), name: "Strategy"), Tag(id: UUID(), name: "Multiplayer")],
            pictures: [URL(string: "https://cdn1.epicgames.com/offer/24b9b5e323bc40eea252a10cdd3b2f10/EGS_LeagueofLegends_RiotGames_S2_1200x1600-905a96cea329205358868f5871393042")!, URL(string: "https://interfaceingame.com/wp-content/uploads/league-of-legends/league-of-legends-cover-375x500.jpg")!],
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio velit, accumsan id erat sed, faucibus tristique lectus. Sed condimentum libero scelerisque tincidunt scelerisque. Nulla venenatis tellus id erat mollis, eget cursus lorem dignissim. Sed luctus hendrerit nisi id molestie. Integer enim lorem, lacinia a dignissim sit amet, ullamcorper et nunc.",
            popularity: 1,
            community: 987654,
            reviews: [],
            releaseYear: 2009,
            rating: 4.5,
            platform: ["Windows", "MacOS", "Linux"],
            multiplayerSupport: true,
            price: 59.99,
            developers: ["Developer 1", "Developer 2"]
        )
    }
}
