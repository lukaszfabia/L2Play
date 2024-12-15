//
//  ForgotPasswordView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var showPinField: Bool = false
    
    private let passwordRestoring0 = NSLocalizedString("PasswordRestoringTitle0", comment: "")
    private let passwordRestoring1 = NSLocalizedString("PasswordRestoringTitle1", comment: "")
    private let noteForPassRest0 = NSLocalizedString("NoteForPasswordRestoring0", comment: "")
    private let noteForPassRest1 = NSLocalizedString("NoteForPasswordRestoring1", comment: "")
    
    var body: some View {
        NavigationStack { 
            ScrollView {
                VStack {
                    Image("resote_password")
                        .resizable()
                        .frame(width: 300, height: 210)
                        .padding(.top, 30)
                    
                    Text(noteForPassRest0)
                        .foregroundStyle(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Section {
                        CustomFieldWithIcon(
                            acc: $email,
                            placeholder: "Email...",
                            icon: "envelope",
                            isSecure: false
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    }
                    .padding()
//                    
//                    ButtonWithIcon(color: .accentColor, text: Text("Send an e-mail"), icon: "arrow.clockwise.circle") {
//                        showPinField.toggle()
//                    }
                }
                .sheet(isPresented: $showPinField) {
                    PinCodeView()
                }
            }
            .navigationTitle("Password restoring")
        }
    }
}


struct PinCodeView: View {
    @State private var showNewPasswordField : Bool = false
    @State private var newPassword: String = ""
    
    private let newPassword_ = NSLocalizedString("NewPasswordPlaceholder", comment: "")
    
    var body: some View {
        if !showNewPasswordField {
            OtpField(f: {
                verify()
            })
        } else {
            EmptyView()
        }
        
        if showNewPasswordField {
            VStack {
                HStack{
                    Text("Now you just need to set a new password")
                        .font(.largeTitle)
                        .fontWeight(.light)
                }.padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                Image("new_password")
                    .resizable()
                    .frame(width: 300, height: 230)
                
                
                
                CustomFieldWithIcon(acc: $newPassword, placeholder: newPassword_, icon: "lock", isSecure: true)
                    .padding()
                    .autocorrectionDisabled()
                    .keyboardType(.alphabet)
                
//                ButtonWithIcon(color: .accentColor, text: Text("Change"), icon: "arrow.triangle.2.circlepath",){
//                    
//                }
//                .padding(.vertical)
                
            }.padding()
        } else {
            EmptyView()
        }
    }
    
    private func verify() {
        // if veried set showpasswordfield
        showNewPasswordField.toggle()
    }
    
}
