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
        let _ = await performAsyncOperation {
            await self.fetchReviewsForGame()
        }
        
        let result: Result<Game, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .games, id: self.game.id.uuidString)
        }
        
        switch result {
        case .success(let fetchedGame):
            self.game = fetchedGame
            break
        case .failure(let error):
            print("Failed to refresh user: \(error.localizedDescription)")
            self.errorMessage = "Failed to refresh game"
            break
        }
        
    }
    
    func addGame(state: GameState) async {
        guard state != .notPlayed else {return}
        
        user.toggleGame(game: game, state: state)
    
        let result: Result<_, Error> =  await performAsyncOperation {
            try await self.manager.update(collection: .users, id: self.user.id, object: self.user)
        }
        
        switch result {
        case .success:
            self.user = user
            
            await updatePopularity()
            
            break
        case .failure(let error):
            print("Failed to update user: \(error.localizedDescription)")
            self.errorMessage = "Failed to update user"
            break
        }
    }
    
    func fetchReviewsForGame() async {
        let result: Result<[Review], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .reviews, whereIs: ("gameID", self.game.id.uuidString))
        }
        
        switch result {
        case .failure(let error):
            print("Failed to fetch all reviews: \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch all reviews"
            break
            
        case .success(let fetchedReviews):
            self.reviews = fetchedReviews.sorted {
                $0.createdAt > $1.createdAt
            }
            
            // set current user review as a first
            if let index = self.reviews.firstIndex(where: {$0.author.id == user.id}) {
                let currUserReivew = self.reviews[index]
                self.reviews.remove(at: index)
                self.reviews.insert(currUserReivew, at: 0)
            }
            
            break
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
            case .failure(let error):
                print("Failed to update review: \(error.localizedDescription)")
                self.errorMessage = "Failed to update review"
                break
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
            case .failure(let error):
                print("Failed to create review: \(error.localizedDescription)")
                self.errorMessage = "Failed to create review"
                break
            }
        }
        
        await updateGameRating()
    }
    
    private func updatePopularity() async {
        // some stuff
    }
    
    private func updateGameRating() async {
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
        
        result = result < 0 ? 0 : result / Double(reviewCount)
        
        
        self.game.rating = result
        
        let r: Result<_, Error> = await performAsyncOperation {
            try await self.manager.update(collection: .games, id: self.game.id.uuidString, object: self.game)
        }
        
        switch r {
        case .success:
            await refreshGame()
            break
        case .failure(let error):
            print("Failed to update game: \(error.localizedDescription)")
            self.errorMessage = "Failed to update game"
            
        }
        
    }
}
