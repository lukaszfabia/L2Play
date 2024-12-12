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
    
    var game: Game
    @Published private(set) var user: User
    @Published var reviews: [Review] = []
    
    var reviewCount: Int {
        reviews.count
    }
    
    private let manager: FirebaseManager = FirebaseManager()
    
    
    init(game: Game, user: User) {
        self.game = game
        self.user = user
    }
    
    func refreshGame() async {
        _ = await performAsyncOperation {
            await self.fetchReviewsForGame()
        }
        
        let result: Result<Game, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .games, id: self.game.id.uuidString)
        }
        
        if case .success(let success) = result {
            self.game = success
        }
    }
    
    func addGame(state: GameState) async {
        user.toggleGame(game: game, state: state)
        
        //remove games tagged as a not pxlayed
        self.user.games = self.user.games.filter{$0.state != .notPlayed}
        
        let result: Result<_, Error> =  await performAsyncOperation {
            try await self.manager.update(collection: .users, id: self.user.id, object: self.user)
        }
        
        if case .success = result {
            self.user = user
            
            await updatePopularityAndCommunity(for: state)
        }
    }
    
    func fetchReviewsForGame() async {
        let result: Result<[Review], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .reviews, whereIs: ("gameID", self.game.id.uuidString))
        }
        
        if case .success(let fetchedReviews) = result {
            self.reviews = fetchedReviews.sorted {
                $0.createdAt > $1.createdAt
            }
            
            // set current user review as a first
            if let index = self.reviews.firstIndex(where: {$0.author.id == user.id}) {
                let currUserReivew = self.reviews[index]
                self.reviews.remove(at: index)
                self.reviews.insert(currUserReivew, at: 0)
            }
        }
    }
    
    func addReview(content: String, rating: Int) async {
        let userReview = reviews.first {$0.author.id == user.id}
        
        if let userReview {
            userReview.updateReview(newReview: content, newRating: rating)
            
            let updateResult: Result<_, Error> = await performAsyncOperation {
                try await self.manager.update(collection: .reviews, id: userReview.id.uuidString, object: userReview)
            }
            
            switch updateResult {
            case .success:
                // swap reviews
                if let i = reviews.firstIndex(where: { $0.gameID == userReview.gameID }) {
                    reviews[i] = userReview
                }
                break
            case .failure:
                return
            }
            
        } else {
            let newReview = Review(review: content, rating: rating, gameID: game.id, author: Author(user: user))
            
            let createResult: Result<Review, Error> = await performAsyncOperation {
                try await self.manager.create(collection: .reviews, object: newReview, customID: newReview.id.uuidString)
            }
            
            switch createResult {
            case .success(let fetchedReview):
                self.reviews.append(fetchedReview)
                break
            case .failure:
                return
            }
        }
        
        await updateGameRating()
    }
    
    private func updatePopularityAndCommunity(for state: GameState) async {
        if state != .notPlayed && !self.game.userInCommunity(user.id) {
            self.game.expandCommunity(user.id)
        } else if state == .dropped {
            self.game.removeFromCommunity(user.id)
        }
        
        let w1: Double = 0.3 // weight reviews
        let w2: Double = 0.4 // weight rating
        let w3: Double = 0.2 // weight "dropped"
        let w4a: Double = 0.1 // weight "playing"
        let w4b: Double = 0.1 // weight "completed"
        let w5: Double = 0.2 // community weight
        
        let reviewsCount = Double(reviews.count)
        
        var dict: [GameState: Int] = [:]
        
        // get all users game with current preprocessed game state - cardinality
        let result: Result<[User], Error> = await performAsyncOperation { [self] in
            try await self.manager.findAll(collection: .users, whereIs: ("games.gameID", game.id.uuidString))
        }
        
        if case .success(let users) = result {
            users.forEach { user in
                user.games
                    .filter { $0.gameID == game.id }
                    .forEach { dict[$0.state, default: 0] += 1 }
            }
        } else if case .failure = result {
            return
        }
        
        // counts
        let playingCount = Double(dict[.playing] ?? 0)
        let completedCount = Double(dict[.completed] ?? 0)
        let droppedCount = Double(dict[.dropped] ?? 0)
        let communityWeight = Double(game.community)
        
        // normalize to minimum
        let normalizedReviews = normalize(value: reviewsCount, min: 0, max: 1000)
        let normalizedRating = normalize(value: game.rating, min: 0, max: 10, inverse: true)
        let normalizedPlayingCount = normalize(value: playingCount, min: 0, max: 100)
        let normalizedCompletedCount = normalize(value: completedCount, min: 0, max: 100)
        let normalizedDroppedCount = normalize(value: droppedCount, min: 0, max: 100)
        let normalizedCommunityWeight = normalize(value: communityWeight, min: 0, max: 500)
        
        let popularity = Int(
            w1 * normalizedReviews +
            w2 * normalizedRating +
            w4a * normalizedPlayingCount +
            w4b * normalizedCompletedCount +
            w3 * normalizedDroppedCount +
            w5 * normalizedCommunityWeight
        )
        
        self.game.popularity = popularity
        
        
        _ = await performAsyncOperation{ [self] in
            try await manager.update(collection: .games, id: game.id.uuidString, object: game)
        }
    }
    
    private func normalize(value: Double, min: Double, max: Double, inverse: Bool = false) -> Double {
        let normalizedValue = (value - min) / (max - min)
        return inverse ? 1 - normalizedValue : normalizedValue
    }
    
    private func updateGameRating() async {
        guard !reviews.isEmpty else { return }
        
        var totalWeightedRating: Double = 0.0
        var totalWeights: Double = 0.0
        
        for review in reviews {
            let dislikes = Double(review.dislikes.count)
            let likes = Double(review.likes.count)
            let rating = Double(review.rating)
            var weight: Double = 0.0
            
            if dislikes < likes {
                weight = likes - dislikes
            } else if likes == dislikes {
                weight = 1.0
            }
            
            totalWeights += weight
            totalWeightedRating += weight * rating
        }
        
        self.game.rating = totalWeights > 0 ? totalWeightedRating / totalWeights : 0.0
        
        _ = await performAsyncOperation {
            try await self.manager.update(collection: .games, id: self.game.id.uuidString, object: self.game)
        }
    }
    
}
