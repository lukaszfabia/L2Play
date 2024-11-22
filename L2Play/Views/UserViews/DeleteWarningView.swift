//
//  DeleteAccountView.swift
//  ios
//
//  Created by Rychu on 07/11/2024.
//

import SwiftUI

struct DeleteAccountView: View {
    private let info0 = NSLocalizedString("DeleteWarn0", comment: "")
    private let info1 = NSLocalizedString("DeleteWarn1", comment: "")
    @State private var email: String = ""
    @State private var showConfirmationAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                
                Text(info0)
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Image("delete_account")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 210)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                
                VStack {
                    Text(info1)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .background(Color.gray.opacity(0.15))
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal)

                CustomFieldWithIcon(acc: $email, placeholder: "Email...", icon: "envelope", isSecure: false)
                    .padding(.horizontal)
                
                Spacer().frame(height: 20)
                
                ButtonWithIcon(color: .red, text: Text("Delete"), icon: "xmark"){
                    showConfirmationAlert.toggle()
                }
                .frame(width: 200, height: 50)
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(25)
                .shadow(radius: 5)
                .padding(.top)
                .alert(isPresented: $showConfirmationAlert) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            // delete function goes here...
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Delete Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    DeleteAccountView()
}
