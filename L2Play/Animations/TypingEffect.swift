//
//  TypingEffect.swift
//  ios
//
//  Created by Lukasz Fabia on 19/10/2024.
//

import SwiftUI

struct TypingEffect: View {
    @State private var displayed: String = ""
    @State private var currentPromptIndex: Int = 0
    @State private var isTyping: Bool = true
    @State private var isErasing: Bool = false
    
    
    let prompts: [String]
    let fontColor: Color
    
    private let typingDelay: TimeInterval = 0.1
    private let erasingDelay: TimeInterval = 0.05
    private let pauseDuration: TimeInterval = 1.0
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GradientText(text: Text(displayed), customFontSize: .largeTitle)
            .onReceive(timer) { _ in
                if isTyping {
                    typingEffect()
                } else if isErasing {
                    erasingEffect()
                }
            }
            .onAppear {
                startTyping()
            }
    }

    private func startTyping() {
        displayed = ""
        isTyping = true
        isErasing = false
    }

    private func typingEffect() {
        guard currentPromptIndex < prompts.count else { return }
        
        let currentPrompt = prompts[currentPromptIndex]
        
        if displayed.count < currentPrompt.count {
            let nextIndex = currentPrompt.index(currentPrompt.startIndex, offsetBy: displayed.count)
            displayed.append(currentPrompt[nextIndex])

        } else {
            isTyping = false
            DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) {
                isErasing = true
            }
        }
    }

    private func erasingEffect() {
        guard currentPromptIndex < prompts.count else { return }
        
        _ = prompts[currentPromptIndex]
        
        if !displayed.isEmpty {
            displayed.removeLast()
        } else {
            
            isErasing = false
            currentPromptIndex = (currentPromptIndex + 1) % prompts.count
            startTyping()
        }
    }
}

#Preview {
    TypingEffect(prompts: ["Hello, World!", "Welcome to SwiftUI!", "Enjoy coding!"], fontColor: .white)
}
