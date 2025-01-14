//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var provider: AuthViewModel

    @State private var password: String = ""
    @State private var email: String = ""
    @State private var isAuth: Bool = false
        
    var isFormValid: Bool {
        return !password.isEmpty && !email.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 6) {
                    HStack {
                        GradientText(text: Text("Welcome".localized()), customFontSize: .title)
                            .accessibilityLabel("Welcome Label")
                        
                        Text("back".localized())
                            .fontWeight(.thin)
                            .font(.title)
                            .accessibilityLabel("Back Label")
                        
                        Text("👋")
                            .font(.title)
                            .accessibilityLabel("Hand Emoji")
                    }
                    .padding()
                    
                    if let err = provider.errorMessage {
                        VStack {
                            Text(err)
                                .font(.title3)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                                .accessibilityLabel("Error Message: \(err)")
                        }
                    }
                    
                    VStack {
                        Text("Time to get back in the game!".localized())
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                            .accessibilityLabel("Prompt0")
                        
                        Text("Log in to access your account!".localized())
                            .foregroundStyle(.gray)
                            .accessibilityLabel("Prompt1")
                    }
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    VStack {
                        Section {
                            CustomFieldWithIcon(acc: $email, placeholder: "joe.doe@example.com", icon: "envelope", isSecure: false)
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .accessibilityLabel("Email address")
                            
                            CustomFieldWithIcon(acc: $password, placeholder: "", icon: "lock", isSecure: true)
                                .autocorrectionDisabled()
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.never)
                                .accessibilityLabel("Password")
                        }
                        .padding()
                        
                        HStack {
                            NavigationLink(destination: ForgotPasswordView()) {
                                Text("Forgot password?".localized())
                                    .foregroundStyle(.link)
                                    .fontWeight(.light)
                                    .font(.system(size: 12))
                                    .accessibilityLabel("Forgot password link")
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("Don't have an account?".localized())
                                    .foregroundStyle(.link)
                                    .fontWeight(.light)
                                    .font(.system(size: 12))
                                    .accessibilityLabel("Don't have an account link")
                            }
                        }
                        .padding()
                        
                        VStack {
                            Button(action: login) {
                                HStack {
                                    if provider.isLoading {
                                        LoadingView()
                                            .accessibilityLabel("Loading spinner")
                                    } else {
                                        Image(systemName: "arrow.right")
                                            .frame(width: 24, height: 24)
                                        
                                        Text("Sign In".localized())
                                            .font(.headline)
                                    }
                                }
                                .padding()
                                .frame(width: 200)
                                .background(!isFormValid ? Color.gray : Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .disabled(!isFormValid)
                                .accessibilityLabel("Sign in button")
                            }

                            CustomDivider(text: Text("or".localized()))
                                .accessibilityLabel("Or Divider")
                            
                            GoogleButton {
                                provider.continueWithGoogle(presenting: getRootViewController())
                            }
                            .accessibilityLabel("Continue with Google button")
                        }
                    }
                    .cornerRadius(20)
                    
                    Spacer()
                    
                    VStack {
                        Text("By signing in, you agree to our Terms of Service and Privacy Policy.".localized())
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                            .accessibilityLabel("Terms and Privacy Policy Agreement")
                    }
                }
                .padding()
                .navigationTitle("Login".localized())
                .navigationDestination(isPresented: $isAuth) {
                    MainView()
                }
                .accessibilityLabel("Login")
            }
        }
    }
    
    private func login() {
        provider.login(email: email, password: password)
        isAuth = provider.isAuthenticated
        isAuth ? HapticManager.shared.generateSuccessFeedback() : HapticManager.shared.generateSuccessFeedback()
    }
}
