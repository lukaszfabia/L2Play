//
//  Button.swift
//  L2Play
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import SwiftUI

struct GoogleButton: View {
    var action: () -> Void

    
    var body: some View {
        Button(action: action) {
            HStack {
                Image("google-icon")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("Continue with Google")
            }.frame(maxWidth: 300)
                .padding()
                .background(Color(.systemGray6))
                .foregroundColor(.primary)
                .cornerRadius(40)
        }
    }
    
}

struct ButtonWithIcon: View {
    var color: Color
    var text: Text
    var icon: String?
    var action: () -> Void
    var w: CGFloat = 200
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed.toggle()
            }
            action()
        }) {
            HStack {
                if let i = icon {
                    Image(systemName: i)
                        .frame(width: 24, height: 24)
                }
                text
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: w)
            .background(isPressed ? color.opacity(0.8) : color)
            .foregroundColor(.white)
            .cornerRadius(40)
            .scaleEffect(isPressed ? 0.95 : 1)
            .shadow(radius: isPressed ? 5 : 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct RadioButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isSelected ? Color.indigo : Color.gray.opacity(0.2))
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}



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
