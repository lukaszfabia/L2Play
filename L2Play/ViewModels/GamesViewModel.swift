//
//  GamesViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import Foundation

@MainActor
class GamesViewModel: ObservableObject, AsyncOperationHandler {

    private let manager: FirebaseManager = FirebaseManager()
    @Published var games: [Game] = []
    @Published var recommendedGames: [Item] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    
    func fetchRecommendations() {
        // todo
    }
    
    func fetchGames(ids: [UUID]? = nil) async -> [Game] {
        let result: Result<[Game], Error> = await performAsyncOperation {
            return try await self.manager.findAll(collection: .games, ids: ids)
        }
        
        switch result {
        case .success(let games):
            self.games = games
            return self.games
        case .failure:
            return []
        }
    }

    func fetchUsersPlaylist(user: User?) async -> [Game] {
        guard let user else {return []}
        
        let result: Result<[Game], Error> = await performAsyncOperation {
            return await self.fetchGames(ids: user.playlist)
        }
        
        switch result {
        case .success(let games):
            return games
        case .failure:
            return []
        }
    }
    
    func fetchFavs(user: User?) async -> [Item] {
        guard let user else {return []}
        let result: Result<[Item], Error> = await performAsyncOperation {
            let games = await self.fetchGames(ids: user.favGames)
            return games.map { Item(game: $0) }
        }
        
        switch result {
        case .success(let items):
            return items
        case .failure:
            return []
        }
    }
}
