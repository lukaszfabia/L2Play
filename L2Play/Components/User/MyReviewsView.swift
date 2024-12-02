//
//  MyReviewsView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI
import Foundation

struct MyReviewsView: View {
    @Binding var reviews: [Review]
    @EnvironmentObject private var provider : AuthViewModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Reviews")
                .font(.largeTitle)
                .fontWeight(.light)
            
            if reviews.isEmpty {
                Text("No reviews yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(reviews, id: \.id) { review in
                    ReviewShowcase(reviewViewModel: ReviewViewModel(user: provider.user, review: review), refreshUser: {Task {
                        await provider.refreshUser(provider.user)
                    }})
                }
            }
        }
    }
}
