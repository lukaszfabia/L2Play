//
//  Text.swift
//  ios
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import SwiftUI

struct GradientText: View {
    var text: String
    var customFontSize: CGFloat?
    @State private var isAnimating: Bool = true

    var body: some View {
        Text(text)
            .font(customFontSize != nil ? .system(size: customFontSize!): .largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.clear)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: isAnimating ? gradientList : gradientList.reversed()),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .mask(
                    Text(text)
                        .font(customFontSize != nil ? .system(size: customFontSize!): .largeTitle)
                        .fontWeight(.bold)
                )
            )
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
    }
}
