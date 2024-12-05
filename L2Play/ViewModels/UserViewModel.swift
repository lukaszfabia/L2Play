//
//  UserViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject, AsyncOperationHandler {
    private let manager: FirebaseManager = FirebaseManager()
    
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    
    init(user: User? = nil) {
        self.user = user
    }
    
    
    func refreshUser() async {
        guard let user else { return }
        
        let result: Result<User, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .users, id: user.id)
        }
        
        switch result {
        case .success(let fetchedUser):
            self.user = fetchedUser
        case .failure(let error):
            print("Failed to refresh user: \(error.localizedDescription)")
            self.errorMessage = "Failed to refresh user."
        }
    }
    
    func fetchReviewsForUser(user: User) async -> [Review] {
        let r : Result<[Review], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .reviews, whereIs: ("author.id", user.id))
        }
        
        switch r {
        case .success(let fetchedReviews):
            return fetchedReviews
        case .failure:
            return []
        }
    }
    

    func fetchUser(with id: String?) async {
        guard let id else {return}
        
        let result: Result<User, Error> = await performAsyncOperation {
            let user: User = try await self.manager.read(collection: .users, id: id)
            return user
        }
        
        switch result {
        case .success(let fetchedUser):
            self.user = fetchedUser
            break
        case .failure:
            break
        }
    }
    
    func getAllWithIds(_ ids: [String]) async -> [User] {
        if ids.isEmpty {
            return []
        }
        
        let result: Result<[User], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .users, ids: ids)
        }
        
        switch result {
        case .failure:
            return []
        case .success(let fetchedUsers):
            return fetchedUsers
        }
    }
    
    // use it on explore view
    func fetchGames() async -> [Game] {
        let result: Result<[Game], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .games)
        }
        
        switch result {
        case .success(let success):
            return success
        case .failure:
            return []
        }
    }
    
    func fetchGame(with id: UUID) async -> Game? {
        let result: Result<Game, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .games, id: id.uuidString)
        }
        
        switch result {
        case .success(let success):
            return success
        case .failure:
            return nil
        }
        
    }
    
    func fetchRecommendedGames() async -> [Item] {
        return []
    }
    
    func getReceiverID(for chat: Chat, currentUserID: String) -> String? {
        return chat.participants.keys.first { $0 != currentUserID }
    }
}
