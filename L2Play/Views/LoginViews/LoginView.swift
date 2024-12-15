//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import SwiftUI


struct LoginView: View {
    @EnvironmentObject var provider: AuthViewModel
//    @EnvironmentObject var t: TranslatorService

    @State private var password: String = ""
    @State private var email: String = ""
    @State private var isAuth: Bool = false
        
    var isFormValid: Bool {
        return !password.isEmpty && !email.isEmpty
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical){
                VStack(alignment: .center, spacing: 6) {
                    HStack {
                        GradientText(text: Text("Welcome"), customFontSize: .title)
                        
                        Text("back")
                            .fontWeight(.thin)
                            .font(.title)
                        
                        Text("👋")
                            .font(.title)
                    }
                    .padding()
                    
                    if let err = provider.errorMessage {
                        VStack {
                            Text(err)
                                .font(.title3)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    
                    
                    VStack {
                        Text("Time to get back in the game!")
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                        Text("Log in to access your account!")
                            .foregroundStyle(.gray)
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
                            
                            CustomFieldWithIcon(acc: $password, placeholder: "", icon: "lock", isSecure: true)
                                .autocorrectionDisabled()
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.never)
                        }
                        .padding()
                        
                        HStack {
                            NavigationLink(destination: ForgotPasswordView()) {
                                Text("Forgot password?")
                                    .foregroundStyle(.link)
                                    .fontWeight(.light)
                                    .font(.system(size: 12))
                            }.disabled(true)
                            
                            Spacer()
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("Don't have an account?")
                                    .foregroundStyle(.link)
                                    .fontWeight(.light)
                                    .font(.system(size: 12))
                            }
                        }.padding()
                        
                        
                        VStack{
                            Button(action: login) {
                                HStack {
                                    if provider.isLoading {
                                        LoadingView()
                                    } else {
                                        Image(systemName: "arrow.right")
                                            .frame(width: 24, height: 24)
                                        
                                        Text("Sign In")
                                            .font(.headline)
                                    }
                                }
                                .padding()
                                .frame(width: 200)
                                .background(!isFormValid ? Color.gray : Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .disabled(!isFormValid)
                            }

                            
                            CustomDivider(text: Text("or"))
                            
                            GoogleButton{
                                provider.continueWithGoogle(presenting: getRootViewController())
                            }
                            
                        }
                    }
                    .cornerRadius(20)
                    
                    Spacer()
                    
                    VStack{
                        Text("By signing in, you agree to our Terms of Service and Privacy Policy.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding()
                .navigationTitle("Login")
                .navigationDestination(isPresented: $isAuth) {
                    MainView()
                }
            }
        }
    }
    
    private func login() {
        provider.login(email: email, password: password)
        
        isAuth = provider.isAuthenticated
        
        isAuth ? HapticManager.shared.generateSuccessFeedback() : HapticManager.shared.generateSuccessFeedback()
    }
}
