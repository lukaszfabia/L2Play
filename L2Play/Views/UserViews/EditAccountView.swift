//
//  EditAccountView.swift
//  ios
//
//  Created by Lukasz Fabia on 10/10/2024.
//

import SwiftUI

struct EditAccountView: View {
    @EnvironmentObject private var provider: AuthViewModel
    
    @State private var firstName: String = ""
    @State private var lastName : String = ""
    @State private var password: String = ""
    @State private var email : String = ""
    
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @Binding var isSettingsPresented: Bool
    
    private let width: CGFloat = 200
    private let height: CGFloat = 200
    
    private let firstName_ = NSLocalizedString("First name", comment: "")
    private let lastName_ = NSLocalizedString("Last name", comment: "")
    
    var body: some View {
        NavigationStack {
            if provider.isLoading {
                LoadingView()
            } else if provider.errorMessage != nil {
                Text("Error: \(String(describing: provider.errorMessage))")
            } else {
                ScrollView(.vertical) {
                    VStack (alignment: .center) {
                        // change avatar
                        Button(action: {
                            showImagePicker = true
                        }) {
                            ZStack {
                                if let image = selectedImage {
                                    LocalImage(pic: image, w: width, h: height)
                                } else {
                                    UserImage(pic: provider.user.profilePicture, initial: provider.user.fullName(), w: width, h: height)
                                }
                                
                                
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .offset(x: 70, y: 70)
                            }
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                        
                        
                        VStack {
                            Text("Personal informations")
                                .font(.title)
                                .padding()
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                        }
                        
                        VStack(alignment: .leading) {
                            
                            Section(header: Text("Who are you?")
                                .font(.headline).foregroundStyle(.primary)) {
                                    CustomFieldWithIcon(acc: $firstName, placeholder: provider.user.firstName ?? "", icon: "person", isSecure: false)
                                        .keyboardType(.alphabet)
                                        .textInputAutocapitalization(.sentences)
                                    
                                    
                                    CustomFieldWithIcon(acc: $lastName, placeholder: provider.user.lastName ?? "", icon: "person", isSecure: false)
                                        .keyboardType(.alphabet)
                                        .textInputAutocapitalization(.sentences)
                                    
                                }.padding(10)
                            
                            
                            if !provider.loggedByExternalPlatform() {
                                Section(header: Text("Login passes")
                                    .font(.headline)
                                    .foregroundColor(.primary)){
                                        CustomFieldWithIcon(acc: $email, placeholder: provider.user.email, icon: "envelope", isSecure: false)
                                            .autocorrectionDisabled()
                                            .keyboardType(.emailAddress)
                                            .textInputAutocapitalization(.never)
                                        
                                        
                                        CustomFieldWithIcon(acc: $password, placeholder: "New password".localized(), icon: "lock", isSecure: true)
                                            .autocorrectionDisabled()
                                            .keyboardType(.alphabet)
                                            .textInputAutocapitalization(.never)
                                    }
                                    .padding(10)
                            }
                            
                        }.padding(.bottom, 10)
                    }
                    .navigationTitle("Edit Account")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: updateMe) {
                                Text("Save")
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    
    private func updateMe() {
        Task {
            if firstName.isEmpty {
                firstName = provider.user.firstName ?? "Unknown"
            }
            
            if lastName.isEmpty {
                lastName = provider.user.lastName ?? "User"
            }
            
            if provider.loggedByExternalPlatform() {
                await provider.editMe(firstName: firstName, lastName: lastName, pic: selectedImage)
            } else {
                await provider.editMe(firstName: firstName, lastName: lastName, email: email, password: password, pic: selectedImage)
            }
        }
        
        DispatchQueue.main.async {
            isSettingsPresented = false
        }
    }
    
}
