//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 26/09/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var isLoggedIn = false
    @State private var displayedText = ""
    private let fullText = "Zaloguj się"
    private let typingDelay = 0.1

    var body: some View {
        VStack {
            if isLoggedIn {
                Text("Log in")
            } else {
                Text(displayedText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .onAppear(perform: startTyping)
                    Spacer()

                Button(action: loginWithGoogle) {
                    Image("google-icon").renderingMode(.original)
                        .accessibility(label: Text("Sign in with Google"))
                        Spacer()
                        Text("Sign in with Google")
                        Spacer()
                }
            }
        }
        .padding()
    }
    
    private func startTyping() {
        displayedText = ""
        for (index, letter) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + typingDelay * Double(index)) {
                displayedText.append(letter)
            }
        }
    }

    // Funkcja do logowania przez Google
    private func loginWithGoogle() {
        // Tu dodaj logikę logowania przez Google
        // Przykładowo, wywołaj Google Sign-In
        // Zmień isLoggedIn na true po pomyślnym zalogowaniu
    }

    // Funkcja do logowania przez Facebook
    private func loginWithFacebook() {
        // Tu dodaj logikę logowania przez Facebook
        // Zmień isLoggedIn na true po pomyślnym zalogowaniu
    }
}

#Preview {
    LoginView()
}
