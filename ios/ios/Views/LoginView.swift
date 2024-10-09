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
    @State private var tokens: Tokens = Tokens(access: "", refresh: "")
    
    @EnvironmentObject var provider: AuthProvider

    var body: some View {
        NavigationStack {
            
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
                        .foregroundStyle(.gray)
                    + Text(
                        " to continue chatting with friends all around the "
                    )
                    .foregroundStyle(.gray)
                    + Text("world!")
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                }
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                
                
                VStack {
                    Section {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            TextField("Email", text: $email)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            SecureField("Password", text: $password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    }
                    .padding()

                    HStack {
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot password?")
                                .foregroundStyle(.gray)
                                .fontWeight(.light)
                                .font(.system(size: 12))
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Don't have an account?")
                                .foregroundStyle(.gray)
                                .fontWeight(.light)
                                .font(.system(size: 12))
                        }
                    }.padding()


                    VStack{
                        ButtonWithIcon(f: {}, color: Color.indigo, text: "Log in", systemIcon: "arrow.right")
                        
                        CustomDivider(text: "or")
                        
                        ButtonWithIcon(f: {}, color:Color(red: 36 / 255.0, green: 35 / 255.0, blue: 33 / 255.0), text: "Log in via Google", icon: "google-icon")
                    }
                }
                .cornerRadius(20)
                
                VStack{
                    Text("By logging in, you agree to our Terms of Service and Privacy Policy.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                }
            }
            .padding()
            .navigationDestination(isPresented:$isLogged) {
                HomeView()
            }
        }
    }

    private func login() {
        let lv: Validator = LoginValidator(email: email, password: password)

        let ctr: AuthController = AuthController()
        // validate data
        if !lv.validate() {
            // some action
        }

        // call login func
        Task {
            let passes: LoginData = LoginData(email: email, password: password)
            
            tokens = await ctr.login(
                logindata: passes
            )
            
            if tokens.access != "" {
                let user: User? = await UserController().getUser(provider)
                
                if let u = user {
                    provider.setCredentials(isAuth: true, tokens: tokens, user: u)
                }else {
                    // some action
                }
            } else {
                //some action
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthProvider())
}

