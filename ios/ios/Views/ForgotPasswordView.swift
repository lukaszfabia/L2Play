//
//  ForgotPasswordView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email : String = ""
    
    @State private var showPinField : Bool = false
    
    var body: some View {
        ScrollView{
            VStack {
                
                HStack {
                    Text("Password")
                        .font(.largeTitle)
                        .fontWeight(.light)
                    GradientText(text: "restoring", customFontSize: 34)
                }
                
                Image("resote_password")
                    .resizable()
                    .frame(width: 300, height: 210)
                
                Text("Please write your email address below and we'll send you a pin code to reset your password.")
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 1)
                    .multilineTextAlignment(.center)
                
                
                Section {
                    CustomFieldWithIcon(
                        acc: email,
                        placeholder: "Email to restore...",
                        icon: "envelope")
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                }.padding()
                
                Text("After clicking the button you will receive an email with a special pin code to reset your password. Then you have to enter it sheet.")
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.center)
                
                
                
                ButtonWithIcon(f: {showPinField.toggle()}, color: .indigo, text: "Restore", systemIcon: "arrow.clockwise.circle")
            }.sheet(isPresented: $showPinField) {
                PinCodeView()
            }
            
        }.padding(.top, 40)
    }
}

struct PinCodeView: View {
    @State private var showNewPasswordField : Bool = false
    @State private var newPassword: String = ""
    
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

                    
                    
                    CustomFieldWithIcon(acc: newPassword, placeholder: "New password...", icon: "lock", isSecure: true)
                        .padding()
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                    
                    ButtonWithIcon(f: {
                        print("set password")
                    }, color: .indigo, text: "Change", systemIcon: "arrow.triangle.2.circlepath")
                    .padding(.vertical)
                    
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

#Preview {
    ForgotPasswordView().environmentObject(AuthProvider())
}
