//
//  Card.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct GameCard: View {
    let cover: URL
    
    var body: some View {
        HStack(spacing: 12) {
            GameCover(cover: cover)
        }
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
