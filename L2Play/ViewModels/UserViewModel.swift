//
//  UserController.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    private let manager: FirebaseManager = FirebaseManager()
    @Published private var user: User
    
    
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init(user: User){
        self.user = user
    }
    
    

    /// Append to users list
    /// - Parameter uid: user id list
    func followUser(uid: UUID) {
        
    }
    
    func fetchReviewsForUser(user: User) -> [Review] {
        return []
    }
}
