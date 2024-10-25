//
//  RegisterView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI


struct RegisterView: View {
    private let summary: String = "How to make valid password?"
    private let details: [String] = [
        "min. 8 length",
        "max 30 length",
        "at least one big letter",
        "at least one number"
    ]
    @State private var firstName: String = ""
    @State private var lastName : String = ""
    @State private var password: String = ""
    @State private var email : String = ""
    
    @State private var isLogged: Bool = false
    @State private var tokens: Tokens = Tokens(access: "", refresh: "")
    
    @EnvironmentObject var provider: AuthProvider
    
    var body: some View {
        NavigationStack {
            ScrollView{
            VStack(alignment: .center, spacing: 6) {
                HStack {
                    Text("Create your")
                        .fontWeight(.thin)
                        .font(.largeTitle)
                    
                    GradientText(text: "account!")
                    
                }
                .padding()
                
                VStack{
                    ButtonWithIcon(f: {}, color:Color(red: 36 / 255.0, green: 35 / 255.0, blue: 33 / 255.0), text: "Sign up via Google", icon: "google-icon")
                    
                    CustomDivider(text: "or").padding()
                    
                    Text("Sign up with ")
                        .font(.title)
                        .fontWeight(.light)
                    +
                    Text("email address")
                        .bold()
                        .font(.title)
                }
                
                
                VStack {
                    Section {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            TextField("First name", text: $firstName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                        
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                            TextField("Last name", text: $lastName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                        
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
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    
                    AccordionView(summary: summary, details: details)
                    
                    HStack {
                        NavigationLink(destination: LoginView()) {
                            Text("Already have account?")
                                .foregroundStyle(.gray)
                                .fontWeight(.light)
                                .font(.system(size: 12))
                        }
                        Spacer()
                    }.padding()
                    
                }
                .cornerRadius(20)
                
                
                VStack{
                    ButtonWithIcon(f: {}, color: Color.indigo, text: "Sign up", systemIcon: "arrow.right")
                }
                
                VStack{
                    Text("By signing up, you agree to our Terms of Service and Privacy Policy.")
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
    }
}

#Preview {
    RegisterView().environmentObject(AuthProvider())
}
