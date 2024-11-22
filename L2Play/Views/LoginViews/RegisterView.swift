//
//  RegisterView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI


struct RegisterView: View {
    @State private var firstName: String = ""
    @State private var lastName : String = ""
    @State private var password: String = ""
    @State private var email : String = ""
    
    
    @EnvironmentObject var provider: AuthViewModel
    
    private let signupwtih0 = NSLocalizedString("SignUpWith0", comment: "")
    private let signupwtih1 = NSLocalizedString("SignUpWith1", comment: "")
    
    private let summary = NSLocalizedString("ValidPassword0", comment: "")
    
    private let details: [String] = [
        NSLocalizedString("ValidPassword1", comment: ""),
        NSLocalizedString("ValidPassword2", comment: ""),
        NSLocalizedString("ValidPassword3", comment: ""),
        NSLocalizedString("ValidPassword4", comment: "")
    ]
    
    
    private let note = NSLocalizedString("NoteSignUp", comment: "")
    
    private let prompt = NSLocalizedString("RegisterPrompt", comment: "")
    
    private let firstName_ = NSLocalizedString("First name", comment: "")
    private let lastName_ = NSLocalizedString("Last name", comment: "")
    private let password_ = NSLocalizedString("Password", comment: "")
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .center, spacing: 6) {
                    VStack {
                        Text(prompt)
                            .foregroundStyle(.gray)
                    }.padding()
                    
                    VStack{
                        GoogleButton{
                            provider.continueWithGoogle(presenting: getRootViewController())
                        }
                        
                        CustomDivider(text: Text("or")).padding()
                        
                        Text(signupwtih0 + " ")
                            .font(.title2)
                            .fontWeight(.light)
                        +
                        Text(signupwtih1)
                            .bold()
                            .font(.title2)
                    }.padding()
                    
                    
                    VStack {
                        Section {
                            CustomFieldWithIcon(acc: $firstName, placeholder: firstName_, icon: "person", isSecure: false)
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.sentences)
                            
                            CustomFieldWithIcon(acc: $lastName, placeholder: lastName_, icon: "person", isSecure: false)
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.sentences)
                            
                            CustomFieldWithIcon(acc: $email, placeholder: "Email", icon: "envelope", isSecure: false)
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            
                            CustomFieldWithIcon(acc: $password, placeholder: password_, icon: "lock", isSecure: true)
                                .autocorrectionDisabled()
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.never)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        
                        AccordionView(summary: summary, details: details)
                        
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
                    
                    
                    VStack{
                        ButtonWithIcon(color: .accentColor, text: Text("Sign up"), icon: "arrow.right"){
                            provider.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
                        }
                    }
                    
                    VStack{
                        Text(note)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 30)
                    }
                }
                .padding()
                .navigationTitle("Create Account")
                .navigationDestination(isPresented: $provider.isAuthenticated) {
                    HomeView()
                }
            }
        }
    }
}

#Preview {
    RegisterView().environmentObject(AuthViewModel())
}
