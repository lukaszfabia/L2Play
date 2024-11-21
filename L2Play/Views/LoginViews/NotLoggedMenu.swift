//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 26/09/2024.
//

import SwiftUI

struct navigationStack: View {
    private let w: CGFloat = 300
    private let h: CGFloat = 35
    
    
    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .clipShape(CustomCorners(cornerRadii: 60, corners: [.topLeft, .topRight]))
                
                VStack(spacing: 30) {
                    Button(action: {
                        print("Sign in with Google pressed")
                    }) {
                        HStack {
                            Image("google-icon")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("Continue with Google")
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                        .frame(width: w, height: h)
                    }
                    .buttonStyle(CustomButton(
                        buttonColor: Color(.systemGray6)
                    ))
                    
                    
                    NavigationLink(destination: RegisterView()) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.headline)
                            
                            Text("Join to us!")
                                .font(.headline)
                        }
                        .frame(width: w, height: h)
                    }
                    .buttonStyle(CustomButton(
                        buttonColor: .accent
                    ))
                    
                    NavigationLink(destination: LoginView()) {
                        HStack {
                            Image(systemName: "arrow.right.circle")
                                .font(.headline)
                            
                            Text("Login")
                                .font(.headline)
                        }
                        .frame(width: w, height: h)
                    }
                    .buttonStyle(CustomButton(outline: true))
                }
            }
            .frame(width: 410, height: 450)
            .padding(.top, 70)
            
            Spacer()
        }
        .padding()
    }
}

struct NotLoggedMenu: View {
    private let prompts = [
        NSLocalizedString("PromptsForNotLoggedMenu_0", comment: ""),  NSLocalizedString("PromptsForNotLoggedMenu_1", comment: ""),
        NSLocalizedString("PromptsForNotLoggedMenu_2", comment: ""),
    ]
    
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
                            .foregroundStyle(Color.accentColor)
                        +
                        Text("Play")
                            .font(.system(size: 50))
                            .fontWeight(.light)
                            .foregroundStyle(.black)
                    }
                    
                    VStack {
                        TypingEffect(prompts: prompts, fontColor: .black)
                    }.frame(maxWidth: .infinity, maxHeight: 40)
                    
                }
                .padding(.top, 170)
                .frame(maxWidth: .infinity, maxHeight: 400)
                
                navigationStack()
            }
            .background(Color(red: 0.961, green: 0.961, blue: 0.961))
            .padding()
        }
    }
}

#Preview {
    NotLoggedMenu().environmentObject(AuthViewModel())
}
