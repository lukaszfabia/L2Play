//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var isLogged: Bool = false

    var body: some View {
        NavigationStack {
            Spacer()
            
            VStack(alignment: .center, spacing: 6) {
                HStack {
                    GradientText(text: "Welcome")
                    
                    Text("back 👋")
                        .fontWeight(.thin)
                        .font(.largeTitle)
                }
                .padding()
                
                VStack {
                    Text("Log in")
                        .fontWeight(.bold)
                        .secondaryTextStyle()
                    + Text(
                        " to continue chatting with friends all around the "
                    )
                    .secondaryTextStyle()
                    + Text("world!")
                        .fontWeight(.bold)
                        .secondaryTextStyle()
                }
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                
                VStack {
                    Image("sign-in")
                        .resizable()
                        .frame(width: 263, height: 188)
                        .padding(.top, 20)
                }
                
                Spacer()
                
                VStack {
                    Section {
                        TextField("Email", text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                    .padding()
                    
                    HStack {
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot password?")
                                .secondaryTextStyle()
                                .fontWeight(.light)
                                .font(.system(size: 12))
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Don't have an account?")
                                .secondaryTextStyle()
                                .fontWeight(.light)
                                .font(.system(size: 12))
                        }
                    }
                    .padding()
                    Spacer()
                    Button(action: login) {
                        Text("Log in")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.indigo)
                            .cornerRadius(40)
                    }
                }
                .padding()
                .cornerRadius(20)
            }
            .padding()
            .navigationDestination(isPresented:$isLogged) {
                ProfileView()
            }
        }
    }

    private func login() {
        let lv: Validator = LoginValidator(email: email, password: password)

        let ctr: AccountController = AccountController()
        // validate data
        if !lv.validate() {
            // some action
        }

        // call login func
        Task {
            let passes: LoginData = LoginData(email: email, password: password)
            
            let tokens = await ctr.login(
                logindata: passes
            )
            
            if tokens.access != "" {
                isLogged = true
            }
        }
    }
}

#Preview {
    LoginView()
}
