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
        self.isLoading = true
        defer { self.isLoading = false }
        
        guard let user else { return }
        
        let result: Result<User, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .users, id: user.id)
        }
        
        if case .success(let success) = result {
            self.user = success
        }
    }
    
    func fetchReviewsForUser(user: User) async -> [Review] {
        let r : Result<[Review], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .reviews, whereIs: ("author.id", user.id))
        }
        
        return (try? r.get()) ?? []
    }
    
    
    func fetchUser(with id: String?) async {
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        
        guard let id else {return}
        
        let result: Result<User, Error> = await performAsyncOperation {
            return try await self.manager.read(collection: .users, id: id) as User
        }
        
        if case .success(let success) = result {
            self.user = success
        }
        
    }
    
    // get users with provided ids
    func getAllWithIds(_ ids: [String]) async -> [User] {
        self.isLoading = true
        defer {
            self.isLoading = false 
        }
        
        if ids.isEmpty {
            return []
        }
        
        let result: Result<[User], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .users, ids: ids)
        }
        
        return (try? result.get()) ?? []
    }
    
    // use it on explore view
    func fetchGames(ids: [UUID] = []) async -> [Game] {
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        let result: Result<[Game], Error> = await performAsyncOperation {
            if ids.isEmpty {
                try await self.manager.findAll(collection: .games)
            } else {
                try await self.manager.findAll(collection: .games, ids: ids.map{$0.uuidString})
            }
        }
        
        return (try? result.get()) ?? []
    }

    
    func fetchGame(with id: UUID) async -> Game? {
        let result: Result<Game, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .games, id: id.uuidString)
        }
        
        return try? result.get()
    }
    
    func fetchRecommendedGames() async -> [Item] {
        return []
    }
    
    func getReceiverID(for chat: Chat?, currentUserID: String?) -> String? {
        guard let currentUserID, let chat else { return nil }
        return chat.participants.keys.first { $0 != currentUserID }
    }
    
    func getAll(authUser: User) async -> [User] {
        let r: Result<[User], Error> = await performAsyncOperation { [self] in
            try await manager.findAll(collection: .users)
        }
        
        return (try? r.get().filter{$0 != authUser}) ?? []
    }
}
