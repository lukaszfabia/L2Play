//
//  LoginView.swift
//  ios
//
//  Created by Lukasz Fabia on 07/10/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


struct LoginView: View {
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var isLogged: Bool = false
    
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
                    
                    
                    VStack {
                        Section {
                            CustomFieldWithIcon(acc: email, placeholder: "Email", icon: "envelope")
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                            
                            CustomFieldWithIcon(acc: password, placeholder: password_, icon: "lock", isSecure: true)
                                .autocorrectionDisabled()
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.never)
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
                            ButtonWithIcon(color: .accentColor, text: Text("Log in"), icon: "arrow.right") {
                                // some stuff
                            }
                            
                            CustomDivider(text: Text("or"))
                            
                            GoogleButton{
                                // some stuff
                            }
                        }
                    }
                    .cornerRadius(20)
                    
                    VStack{
                        Text(note)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 30)
                    }
                }
                .padding()
                .navigationTitle("Login")
                .navigationDestination(isPresented:$isLogged) {
                    HomeView()
                }
            }
        }
    }
    
    private func login() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
          guard error == nil else {
              print("Błąd podczas logowania Google: \(error!.localizedDescription)")
            // ...
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

            _ = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

          // ...
        }

    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}

