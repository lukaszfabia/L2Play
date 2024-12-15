//
//  MyReviewsView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI

struct ReviewsView: View {
    @Binding var reviews: [Review]
    @EnvironmentObject private var provider: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("My Reviews")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                
                if reviews.isEmpty {
                    Text("No reviews yet.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                } else {
                    ForEach(reviews, id: \.id) { review in
                        ReviewShowcase(
                            reviewViewModel: ReviewViewModel(user: provider.user, review: review)
                        )
                    }
                }
            }
            .padding()
            .navigationTitle("Reviews")
        }
    }
}
