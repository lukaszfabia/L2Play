//
//  WrappedItemsView.swift
//  ios
//
//  Created by Lukasz Fabia on 25/10/2024.
//

import SwiftUI

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
