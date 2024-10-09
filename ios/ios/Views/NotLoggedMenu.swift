//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 26/09/2024.
//

import SwiftUI

struct navigationStack: View {
    var body: some View {
                VStack {
                    ZStack {
                        Color.black
                            .cornerRadius(80)
                        
                        VStack(spacing: 10) {
                            Button(action: {
                                print("Sign in with Google pressed")
                            }) {
                                HStack {
                                    Image("google-icon")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    
                                    Text("Sign in with Google")
                                        .font(.headline)
                                }
                                .frame(width: 300, height: 40)
                            }
                            .buttonStyle(CustomButton(
                                buttonColor: Color(red: 36 / 255.0, green: 35 / 255.0, blue: 33 / 255.0)
                            ))
                            
                            
                            Button(action: {
                                print("Join to us pressed")
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                        .font(.headline)
                                    
                                    Text("Join to us!")
                                        .font(.headline)
                                }
                                .frame(width: 300, height: 40)
                            }
                            .buttonStyle(CustomButton(
                                buttonColor: Color(red: 36 / 255.0, green: 35 / 255.0, blue: 33 / 255.0)
                            ))
                            
                            NavigationLink(destination: LoginView()) {
                                HStack {
                                    Image(systemName: "arrow.right.circle")
                                        .font(.headline)
                                    
                                    Text("Log in")
                                        .font(.headline)
                                }
                                .frame(width: 300, height: 40)
                            }
                            .buttonStyle(CustomButton(outline: true))
                        }
                    }
                    .padding(.bottom, 50)
                    .frame(width: 406, height: 360)
                    .offset(y: 20)
                }
                .padding()
            }
}

struct NotLoggedMenu: View {
    var body: some View {
        NavigationStack{
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
                    GradientText(text: "name")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .offset(y:40)

                // Login options
                ZStack {
                    Color.black
                        .cornerRadius(80)
                    
                    navigationStack()
                }
                .frame(width: 406, height: 360)
                .offset(y: 55)
            }
            .padding()
        }
    }
}

#Preview {
    NotLoggedMenu()
}
