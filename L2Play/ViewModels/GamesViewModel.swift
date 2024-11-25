//
//  GamesViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import Foundation

class GamesViewModel: ObservableObject {
    private let manager: FirebaseManager = FirebaseManager()
    @Published var games: [Game] = []
    @Published var recommendedGames: [Item] = []
    @Published var errorMessage: String = ""
    
    func fetchRecommendations() {
        
        // todo
    }
    
    // Changes state for games when we want to fetch all (in main thread)
    @MainActor
    func fetchGames(ids: [UUID]? = nil) async -> [Game] {
        do {
            self.games = try await self.manager.findAll(collection: "games", ids: ids)
            return self.games
        } catch {
            self.errorMessage = error.localizedDescription
            return []
        }
    }

    
    func fetchUsersPlaylist(user: User) async -> [Game] {
        return await fetchGames(ids: user.playlist)
    }
    
    func fetchFavs(user: User) async -> [Item] {
        
        let games = await fetchGames(ids: user.favGames)
        
        return games.map {Item(game: $0)}
    }
    
    
    func fetchReviewsForGame(game: Game) -> [Review] {
        return []
    }
    
    func fetchReviewsForUser(user: User) -> [Review] {
        return []
    }
}
