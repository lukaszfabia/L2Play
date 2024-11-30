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
    
    @Published var user: User? = nil
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    
    init(user: User? = nil) {
        self.user = user
    }
    
    func isAuth(_ email: String) -> Bool {
        guard let user else { return false }
        return email == user.email
    }
    
    func fetchUserByEmail(_ email: String) async -> User? {
        let result: Result<User, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .users, id: email)
        }
        
        switch result {
        case .success(let fetchedUser):
            self.user = fetchedUser
            return fetchedUser
        case .failure(let error):
            self.errorMessage = "Error fetching user: \(error.localizedDescription)"
            print("\(error.localizedDescription)")
            return nil
        }
    }
    
    func refreshUser() async {
        guard let user else {return}
        
        let result: Result<User, Error> = await performAsyncOperation {
            try await self.manager.read(collection: .users, id: user.email)
        }
        
        switch result {
        case .success(let fetchedUser):
            self.user = fetchedUser
        case .failure(let error):
            print("Failed to refresh user: \(error.localizedDescription)")
            self.errorMessage = "Failed to refresh user."
        }
    }
    
    func isFollowed(by: User) -> Bool {
        guard let user else {return false}
        return by.following.contains(user.id)
    }
    
    func fetchReviewsForUser(user: User) -> [Review] {
        return []
    }
    

    func getUserByID(_ userID: String?) async -> User? {
        guard let userID else {return nil}
        
        let result: Result<User, Error> = await performAsyncOperation {
            let user: User = try await self.manager.read(collection: .users, id: userID)
            return user
        }
        
        switch result {
        case .success(let fetchedUser):
            return fetchedUser
        case .failure:
            return nil
        }
    }
}