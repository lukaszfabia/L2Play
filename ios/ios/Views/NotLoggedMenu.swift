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
            .padding(.top, 40)
            .frame(width: 406, height: 370)
            
            Spacer()
        }
        .padding()
    }
}

struct NotLoggedMenu: View {
    var body: some View {
        NavigationStack{
            VStack {
                Image("moblie_messages")
                    .resizable()
                    .frame(width: 321, height: 295)
                    .offset(y: 50)
                
                  
                HStack {
                    Text("App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                    GradientText(text: "name")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .offset(y: 50)
                

                ZStack {
                    Color.black
                        .cornerRadius(80)
                    
                    navigationStack()
                }
                .offset(y: 55)
            }
            .background(.white)
            .padding()
        }
    }
}

#Preview {
    NotLoggedMenu().environmentObject(AuthProvider())
}
