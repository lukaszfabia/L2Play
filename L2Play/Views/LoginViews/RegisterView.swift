//
//  RegisterView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI


struct RegisterView: View {
    @EnvironmentObject var provider: AuthViewModel
    @State private var firstName: String = ""
    @State private var lastName : String = ""
    @State private var password: String = ""
    @State private var email : String = ""
    
    @State private var isSubmitting : Bool = false
    @State private var isAuth : Bool = false
    
    private let details: [String] = [
        "At least 1 Big letter".localized(),
        "At least 1 Digit".localized(),
        "Mininum 6 characters".localized(),
        "At least 1 Special Sign".localized(),
    ]
    
    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !provider.isLoading
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .center, spacing: 6) {
                    VStack {
                        GoogleButton{
                            provider.continueWithGoogle(presenting: getRootViewController())
                        }
                        
                        CustomDivider(text: Text("or")).padding()
                        
                        
                        Text("Get Started with Email")
                            .font(.title2.bold())
                    }.padding()
                    
                    
                    VStack {
                        Section {
                            CustomFieldWithIcon(acc: $firstName, placeholder: "Joe", icon: "person", isSecure: false)
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.sentences)
                            
                            CustomFieldWithIcon(acc: $lastName, placeholder: "Doe", icon: "person", isSecure: false)
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.sentences)
                            
                            CustomFieldWithIcon(acc: $email, placeholder: "joe.doe@example.com", icon: "envelope", isSecure: false)
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            
                            CustomFieldWithIcon(acc: $password, placeholder: "", icon: "lock", isSecure: true)
                                .autocorrectionDisabled()
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.never)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        
                        AccordionView(summary: "How to make valid password?", details: details)
                        
                        HStack {
                            NavigationLink(destination: LoginView()) {
                                Text("Aleardy have an account?")
                                    .foregroundStyle(.link)
                                    .fontWeight(.light)
                                    .font(.system(size: 12))
                            }
                            Spacer()
                        }.padding()
                        
                    }
                    .cornerRadius(20)
                    
                    
                    Button(action: signup) {
                        HStack {
                            if provider.isLoading {
                                LoadingView()
                            } else {
                                Image(systemName: "arrow.right")
                                    .frame(width: 24, height: 24)
                                
                                Text("Sign Up")
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
                    
                    Text("By signing up, you agree to our Terms of Service and Privacy Policy.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                }
                .padding()
                .navigationTitle("Create Account")
                .navigationDestination(isPresented: $isAuth) {
                    MainView()
                }
            }
        }
    }
    
    private func signup() {
        provider.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
        isAuth = provider.isAuthenticated
        isAuth ? HapticManager.shared.generateSuccessFeedback() : HapticManager.shared.generateSuccessFeedback()
    }
}
