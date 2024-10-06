//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 26/09/2024.
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

struct LoginView: View {
    var body: some View {
        VStack {
            // Main image
            Image("moblie_messages")
                .resizable()
                .frame(width: 321, height: 295)
                .offset(y: 50)
            // App name
            HStack {
                Text("App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("name")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple, .pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text("name")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .offset(y:40)

            // Login options
            ZStack {
                Color.black
                    .cornerRadius(60)
                
                VStack {
                    Button(action: {
                        print("Button pressed")
                    }) {
                        HStack {
                            Image("google-icon")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("Sign in with Google")
                                .font(.headline)
                                .frame(height: 30)
                        }
                        .frame(width: 300, height: 30)
                    }

                    .buttonStyle(CustomButton(
                        buttonColor : Color(red: 36 / 255.0, green: 35 / 255.0, blue: 33 / 255.0)
                    ))
                
                    
                    Button(action: {
                        print("Button pressed")
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.headline)
                                .frame(height: 30)
                            
                            Text("Join to us!")
                                .font(.headline)
                                .frame(height: 30)
                        }
                        .frame(width: 300, height: 30)
                    }
                    .buttonStyle(CustomButton(buttonColor : Color(red: 36 / 255.0, green: 35 / 255.0, blue: 33 / 255.0)))
                    
                    Button(action: {
                        print("Button pressed")
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle")
                                .font(.headline)
                            
                            Text("Log in")
                                .font(.headline)
                                .frame(height: 30)
                        }
                        .frame(width: 300, height: 30)
                    }
                    .buttonStyle(CustomButton(outline: true))
                    
                }
            }
            .frame(width: 406, height: 360)
            .offset(y: 55)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
