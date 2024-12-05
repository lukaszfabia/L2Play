//
//  Game.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

enum GameState: String, Codable, CaseIterable, Identifiable {
    case notPlayed, planned, playing, completed, dropped, favorite
    
    var id: Self {self}
}

class GameWithState: Codable, Identifiable {
    private(set) var id: UUID = .init()
    let gameID: UUID
    let name: String
    let pic: URL
    let studio: String
    var state: GameState
    var description: String
    var updatedAt: Date
    
    
    // MARK: Comparator
    func compare(to other: GameWithState, attribute: SortAttributeForGame, order: SortOption) -> Bool {
        let comparisonResult: Bool

        switch attribute {
        case .name:
            comparisonResult = self.name.localizedCompare(other.name) == .orderedAscending
        case .studio:
            comparisonResult = self.studio.localizedCompare(other.studio) == .orderedAscending
        case .state:
            comparisonResult = self.state.rawValue < other.state.rawValue
        case .updatedAt:
            comparisonResult = self.updatedAt < other.updatedAt
        }

        return order == .ascending ? comparisonResult : !comparisonResult
    }



    
    // MARK: - Helper Methods
    func changeState(to state: GameState) {
        self.state = state
        self.updatedAt = Date()
    }
    
    // MARK: - Initializers
    init(game: Game, state: GameState) {
        self.gameID = game.id
        self.name = game.name
        self.pic = game.pictures[0]
        self.studio = game.studio
        self.state = state
        self.description = game.description
        self.updatedAt = Date()
    }
    
    init(gameID: UUID, name: String, pic: URL, studio: String, state: GameState, addedAt: Date, description: String) {
        self.gameID = gameID
        self.name = name
        self.pic = pic
        self.studio = studio
        self.state = state
        self.updatedAt = addedAt
        self.description = description
    }

    init(name: String, pic: URL, studio: String, state: GameState, description: String) {
        self.gameID = UUID()
        self.name = name
        self.pic = pic
        self.studio = studio
        self.state = state
        self.updatedAt = Date()
        self.description = description
    }

    init(name: String, pic: URL, studio: String, description: String) {
        self.gameID = UUID()
        self.name = name
        self.pic = pic
        self.studio = studio
        self.state = .planned
        self.updatedAt = Date()
        self.description = description
    }

    static func dummy() -> GameWithState {
        return GameWithState(
            gameID: UUID(),
            name: "Cyberpunk 2077",
            pic: URL(string: "https://example.com/cyberpunk.jpg")!,
            studio: "CD Projekt Red",
            state: .playing,
            addedAt: Date(),
            description: "cuhsdiugfiusdfg"

        )
    }
}


class Game: Codable, Identifiable {
    private(set) var id: UUID = .init()
    let name: String
    let studio : String
    let tags: [String]
    let pictures: [URL]
    let description : String
    var popularity: Int // treat as a card
    var community: Int // for ppl who at least playing game
    var rating: Double
    let platform: [String]
    let multiplayerSupport: Bool
    
    // MARK: Initializers
    init() {
        self.id = .init()
        self.name = ""
        self.studio = ""
        self.tags = []
        self.pictures = []
        self.description = ""
        self.popularity = 0
        self.community = 0
        self.rating = 0
        self.platform = []
        self.multiplayerSupport = false
        self._releaseYear = nil
        self._price = nil
    }
    
    
    private var _releaseYear: Int?
    private var _price: Double?
    
    var releaseYear: String {
        if let r = _releaseYear {
            return "\(r)"
        } else {
            return "N/A"
        }
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.name == rhs.name
    }
    
    var price: String {
        if let p = _price  {
            return String(format: "%.2f", p)
        } else {
            return "Free"
        }
    }
}
