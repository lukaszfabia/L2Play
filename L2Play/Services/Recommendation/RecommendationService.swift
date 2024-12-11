//
//  Recommendation.swift
//  L2Play
//
//  Created by Lukasz Fabia on 11/12/2024.
//

final class RecommendationService {
    private var userID: String
    var allGames: [Game]
    var userGames: [GameWithState]
    
    init(userID: String, allGames: [Game], userGames: [GameWithState]) {
        self.userID = userID
        self.allGames = allGames
        self.userGames = userGames
    }
    
    
    /// Predict games based on players played games
    /// - Returns: games ids
    func predict() -> [String] {
        return []
    }
}
