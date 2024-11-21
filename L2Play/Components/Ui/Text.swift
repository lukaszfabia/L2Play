//
//  Text.swift
//  ios
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import SwiftUI

struct GradientText: View {
    var text: Text
    var customFontSize: Font?
    @State private var isAnimating: Bool = true

    var body: some View {
        text
            .font(customFontSize != nil ? customFontSize: .largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.clear)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: isAnimating ? gradientList : gradientList.reversed()),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .mask(
                    text
                        .font(customFontSize != nil ? customFontSize: .largeTitle)
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
