//
//  Cover.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

struct GameCover: View {
    let cover: URL
    var w: CGFloat = 150
    var h: CGFloat = 200
    
    var body: some View {
        ZStack {
            AsyncImage(url: cover) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: w*3/4, height: h*3/4)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                    )
            } placeholder: {
                ZStack {
                    Color.accentColor
                    ProgressView()
                }
                .frame(width: w*3/4, height: h*3/4)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
}

