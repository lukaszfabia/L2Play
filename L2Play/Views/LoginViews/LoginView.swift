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
    
    @EnvironmentObject var provider: AuthViewModel
    
    private let loginInBold = NSLocalizedString("LogInPrompt0", comment: "")
    private let loginCont = NSLocalizedString("LogInPrompt1", comment: "")
    
    
    private let note = NSLocalizedString("NoteSignIn", comment: "")
    
    private let password_ = NSLocalizedString("Password", comment: "")
    
    
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
                        Text(loginInBold)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                        + Text(loginCont)
                            .foregroundStyle(.gray)
                    }
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    
                    VStack {
                        Section {
                            CustomFieldWithIcon(acc: $email, placeholder: "Email", icon: "envelope", isSecure: false)
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            
                            CustomFieldWithIcon(acc: $password, placeholder: password_, icon: "lock", isSecure: true)
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
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("Don't have an account?")
                                    .foregroundStyle(.link)
                                    .fontWeight(.light)
                                    .font(.system(size: 12))
                            }
                        }.padding()
                        
                        
                        VStack{
                            ButtonWithIcon(color: .accentColor, text: Text("Log in"), icon: "arrow.right") {
                                provider.login(email: email, password: password)
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
                        Text(note)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding()
                .navigationTitle("Login")
                .navigationDestination(isPresented:$provider.isAuthenticated) {
                    HomeView()
                }
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}

