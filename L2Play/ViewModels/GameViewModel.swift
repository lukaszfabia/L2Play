//
//  GameViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import Foundation


@MainActor
class GameViewModel: ObservableObject, AsyncOperationHandler {
    @Published var errorMessage: String? = nil
    
    @Published var isLoading: Bool = false
    
//    @Published var game: Game
    var game: Game
    @Published private(set) var user: User
    @Published var reviews: [Review] = []
    
    private let manager: FirebaseManager = FirebaseManager()
    
    var popularity: Int {
        ///
        return 0 
    }
    
    init(game: Game, user: User) {
        self.game = game
        self.user = user
    }
    
    func refreshGame() async {
        let result: Result<Game, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .games, id: self.game.id.uuidString)
        }
        
        switch result {
        case .success(let fetchedGame):
            self.game = fetchedGame
        case .failure(let error):
            print("Failed to refresh user: \(error.localizedDescription)")
            self.errorMessage = "Failed to refresh game"
        }
        
    }
    
    func isOnList() -> Bool {
        return user.playlist.contains(game.id)
    }
    
    func isFav() -> Bool {
        return user.favGames.contains(game.id)
    }
    
    private func toggleGame(for keyPath: WritableKeyPath<User, [UUID]>) async {
        if user[keyPath: keyPath].contains(game.id) {
            if let index = user[keyPath: keyPath].firstIndex(of: game.id) {
                user[keyPath: keyPath].remove(at: index)
            }
        } else {
            user[keyPath: keyPath].append(game.id)
        }
        

        let result: Result<_, Error> =  await performAsyncOperation {
            try await self.manager.update(collection: .users, id: self.user.email, object: self.user)
        }
        
        switch result {
        case .success:
            self.user = user
        case .failure(let error):
            print("Failed to update user: \(error.localizedDescription)")
            self.errorMessage = "Failed to update user"
        }
    }
    
    func toogleFavGameState() async {
        await toggleGame(for: \.favGames)
    }
    
    func toggleGameState()  async {
        await toggleGame(for: \.playlist)
    }
    
    func fetchReviewsForGame() async {
        let result: Result<[Review], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .reviews, whereIs: ("gameID", self.game.id.uuidString))
        }
        
        switch result {
        case .failure(let error):
            print("Failed to fetch all reviews: \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch all reviews"
        case .success(let fetchedReviews):
            self.reviews = fetchedReviews
        }
    }
    

    func updateGameRating() async {
        var result: Double = 0
        let DEFAULT_POWER = 0.1
        
        
        if reviews.isEmpty {
            return
        }
        
        for review in reviews {
            let dislikes = Double(review.dislikes.count)
            let likes = Double(review.likes.count)
            let rating = Double(review.rating)
            
            // check if diff is bigger than 5
            if dislikes != 0 && likes != 0 && abs(dislikes - likes) > 5 {
                let power = likes / (likes + dislikes)
                result += power * rating
            } else {
                result += DEFAULT_POWER * rating
            }
        }
        
        result = result < 0 ? 0 : result / Double(reviews.count)
        
        
        self.game.rating = result
        
        let r: Result<_, Error> = await performAsyncOperation {
            try await self.manager.update(collection: .games, id: self.game.id.uuidString, object: self.game)
        }
        
        switch r {
        case .success:
            await refreshGame()
        case .failure(let error):
            print("Failed to update game: \(error.localizedDescription)")
            self.errorMessage = "Failed to update game"
        }
        
    }
}
