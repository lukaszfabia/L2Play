//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 26/09/2024.
//

import SwiftUI

struct navigationStack: View {
    @EnvironmentObject private var provider: AuthViewModel
    private let w: CGFloat = 300
    private let h: CGFloat = 35
    
    
    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .clipShape(CustomCorners(cornerRadii: 60, corners: [.topLeft, .topRight]))
                
                VStack(spacing: 30) {
                    Button(action: {
                        HapticManager.shared.generateHapticFeedback(style: .light)
                        provider.continueWithGoogle(presenting: getRootViewController())
                    }) {
                        HStack {
                            Image("google-icon")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Continue with Google".localized())
                                .font(.headline)
                                .foregroundStyle(Color(hex: 0xE3E3E3))
                        }
                        .frame(width: w, height: h)
                    }
                    .buttonStyle(CustomButton(
                        buttonColor: Color(hex: 0x131314)
                    ))
                    .accessibilityLabel("Continue with Google button")
                    
                    
                    NavigationLink(destination: RegisterView()) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.headline)
                            
                            Text("Join to us!".localized())
                                .font(.headline)
                        }
                        .frame(width: w, height: h)
                    }
                    .buttonStyle(CustomButton(
                        buttonColor: .accent
                    ))
                    .accessibilityLabel("Sign Up")
                    
                    NavigationLink(destination: LoginView()) {
                        HStack {
                            Image(systemName: "arrow.right.circle")
                                .font(.headline)
                            
                            Text("Login".localized())
                                .font(.headline)
                        }
                        .frame(width: w, height: h)
                    }
                    .buttonStyle(CustomButton(outline: true))
                    .accessibilityLabel("Login")
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
        "PromptsForNotLoggedMenu_0".localized(),
        "PromptsForNotLoggedMenu_1".localized(),
        "PromptsForNotLoggedMenu_2".localized()
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
