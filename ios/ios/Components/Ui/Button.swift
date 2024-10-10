//
//  Button.swift
//  ios
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import SwiftUI

struct CustomButton: ButtonStyle {
    var buttonColor: Color = Color.black
    var outline: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .background(Color(buttonColor))
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .overlay(outline ? RoundedRectangle(cornerRadius: 40)
                .stroke(Color.white, lineWidth: 2)
                : nil)
            .cornerRadius(40)
            .padding(.vertical, 10)
    }
}

struct ButtonWithIcon: View {
    var f: () -> Void
    var color: Color
    var text: String
    var systemIcon: String?
    var icon: String?
    
    var body: some View {
            Button(action: f) {
                HStack {
                    if let i = systemIcon {
                        Image(systemName: i)
                            .frame(width: 24, height: 24)
                    } else if let i = icon {
                        Image(i)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(text)
                        .font(.headline)
                }
                .frame(width: 200)
                .padding()
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(40)
            }
        }
}
