//
//  ReviewViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import Foundation

class ReviewViewModel: ObservableObject {
    private var user: User
    private var game: UUID
    @Published var review: Review?
    
    init(user: User, game: UUID, review: Review? = nil) {
        self.user = user
        self.game = game
        self.review = review
    }
    
    func addLike() {
        
    }
    
    func addDislike() {
        
    }
    
    func addReview(){
        
    }
    
    func addComment() {
        
    }
}
