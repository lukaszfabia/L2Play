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
                    
                    
                    NavigationLink(destination: RegisterView()) {
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

                VStack{
                    VStack(alignment: .center) {
                        Text("L")
                            .font(.system(size: 50))
                            .fontWeight(.light)
                            .foregroundStyle(.black)
                        +
                        Text("2")
                            .font(.system(size: 50))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        +
                        Text("Play")
                            .font(.system(size: 50))
                            .fontWeight(.light)
                            .foregroundStyle(.black)
                    }
                    
                    VStack {
                        TypingEffect(prompts: ["Rate", "Explore", "Track games"], fontColor: .black)
                    }.frame(maxWidth: .infinity, maxHeight: 40)

                }
                .offset(y: 20)
                .frame(maxWidth: .infinity, maxHeight: 400)
                
                
                ZStack {
                    Color.black
                        .cornerRadius(80)
                    
                    navigationStack()
                }
                .offset(y: 50)

            }
            .background(.white)
            .padding()
        }
    }
}

#Preview {
    NotLoggedMenu().environmentObject(AuthProvider())
}
