//
//  UserViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    private let manager: FirebaseManager = FirebaseManager()
    @Published var user: User? = nil
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init(user: User) {
        self.user = user
    }
    
    init(){}
    
    func fetchUserByEmail(_ email: String) async {
        self.isLoading = true
        do {
            let fetchedUser: User = try await manager.read(collection: .users, id: email)
            self.user = fetchedUser
            print(fetchedUser)
            self.isLoading = false
        } catch {
            self.errorMessage = "Error fetching user: \(error)"
            print("\(error.localizedDescription)")
            self.isLoading = false
        }
    }
    
    func refreshUser() async {
        guard let user else { return }
        do {
            let fetchedUser: User = try await self.manager.read(collection: .users, id: user.email)
            self.user = fetchedUser
        } catch let err {
            print("Failed to refresh user: \(err.localizedDescription)")
            self.errorMessage = "Failed to refresh user."
        }
    }
    
    // Is read-only user followed by current user
    func isFollowed(_ authUser: User) -> Bool {
        guard let user else {return false}
        return authUser.following.contains(user.id)
    }
    
    func fetchReviewsForUser(user: User) -> [Review] {
        return []
    }
}
