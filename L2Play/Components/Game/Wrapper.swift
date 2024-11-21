//
//  Wrapper.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct RatingComponent: View {
    var rating: Double
    var reviewsAmount: Int?
    var font: Font = .title3
    
    var body: some View {
        HStack(spacing: 16) {
            HStack {
                Text(String(format: "%.2f", rating))
                    .padding(8)
                    .font(font.bold())
                    .foregroundStyle(.white)
                    .background(Color.accentColor.gradient)
                    .cornerRadius(10)
                
                if let r = reviewsAmount {
                    Image(systemName: "dot.circle.fill").resizable().frame(width: 5, height: 5)
                    
                    // TODO: handle amount of reviews
                    Text(r.shorterNumber())
                        .foregroundStyle(.primary)
                        .font(.headline.bold())
                    Text("reviews")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fontWeight(.light)
                }
            }
        }
    }
}

struct PriceComponent: View {
    let price: Double?
    
    var body: some View {
        if let p = price {
            Text(String(format: "$%.2f", p))
                .padding(8)
                .font(.title3.bold())
                .foregroundStyle(.primary)
                .background(Color.gray.opacity(0.1).gradient)
                    .cornerRadius(12)
        } else {
            Text("Free")
                .padding(8)
                .font(.title3.bold())
                .foregroundStyle(.green.gradient)
                .background(Color.gray.opacity(0.1).gradient)
                    .cornerRadius(12)
        }
    }
}

struct FlowLayout: View {
    let tags: [Tag]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(0..<tags.count, id: \.self) { i in
                if i % 4 == 0 {
                    HStack {
                        ForEach(i..<min(i+4, tags.count), id: \.self) { tagIndex in
                            Text(tags[tagIndex].name)
                                .font(.caption)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                        }
                    }
                }
            }
        }
    }
}
