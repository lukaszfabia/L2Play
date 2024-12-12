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
    let platform: [String]
    let multiplayerSupport: Bool
    
    
    private var _releaseYear: Int?
    private var _price: Double?
    private var _community: [String]
    private var _popularity: Int
    private var _rating: Double
    
    // MARK: Initializers
    init() {
        self.id = .init()
        self.name = ""
        self.studio = ""
        self.tags = []
        self.pictures = []
        self.description = ""
        self._popularity = 0
        self._community = []
        self._rating = 0
        self.platform = []
        self.multiplayerSupport = false
        self._releaseYear = nil
        self._price = nil
    }
    
    init(name: String, studio: String, tags: [String], pictures:[URL], description: String, platform: [String], multiplayerSupport: Bool, price: Double, releaseYear: Int){
        self.name = name
        self.studio = studio
        self.tags = tags
        self.pictures = pictures
        self.description = description
        self.platform = platform
        self.multiplayerSupport = multiplayerSupport
        
        self._price = price
        self._popularity = 0
        self._rating = 0
        self._community = []
        
        self._releaseYear = releaseYear
    }
    

    var rating: Double {
        get {
            return _rating
        }
        set {
            _rating = newValue
        }
    }
    
    var popularity: Int {
        get {
            return _popularity
        } set {_popularity = newValue }
    }
    
    var community: Int {
        get {
            return _community.count
        }
    }
    
    func userInCommunity(_ userID: String) -> Bool {
        return _community.contains(userID)
    }
    
    func expandCommunity(_ id: String) {
        _community.append(id)
    }
    
    func removeFromCommunity(_ id: String) {
        _community.removeAll{ id == $0 }
    }
    
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
