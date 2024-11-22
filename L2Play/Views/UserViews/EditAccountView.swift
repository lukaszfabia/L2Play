//
//  EditAccountView.swift
//  ios
//
//  Created by Lukasz Fabia on 10/10/2024.
//

import SwiftUI

struct EditAccountView: View {
    @State private var firstName: String = ""
    @State private var lastName : String = ""
    @State private var password: String = ""
    @State private var email : String = ""
    
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    let user: User
    
    private let width: CGFloat = 200
    private let height: CGFloat = 200
    
    private let firstName_ = NSLocalizedString("First name", comment: "")
    private let lastName_ = NSLocalizedString("Last name", comment: "")
    private let password_ = NSLocalizedString("New Password", comment: "")
    
    var body: some View {
        NavigationStack {
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
                                UserImage(pic: user.profilePicture, w: width, h: height)
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
                                CustomFieldWithIcon(acc: $firstName, placeholder: user.firstName, icon: "person", isSecure: false)
                                    .keyboardType(.alphabet)
                                    .textInputAutocapitalization(.sentences)
                                
                                
                                CustomFieldWithIcon(acc: $lastName, placeholder: user.firstName, icon: "person", isSecure: false)
                                    .keyboardType(.alphabet)
                                    .textInputAutocapitalization(.sentences)
                                
                            }.padding(10)
                        
                        
                        Section(header: Text("Login passes")
                            .font(.headline)
                            .foregroundColor(.primary)){
                                CustomFieldWithIcon(acc: $email, placeholder: "Email", icon: "envelope", isSecure: false)
                                    .autocorrectionDisabled()
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                
                                
                                CustomFieldWithIcon(acc: $password, placeholder: password_, icon: "lock", isSecure: true)
                                    .autocorrectionDisabled()
                                    .keyboardType(.alphabet)
                                    .textInputAutocapitalization(.never)
                            }
                            .padding(10)
                        
                    }.padding(.bottom, 10)
                }
                .navigationTitle("Edit Account")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // magic
                        }) {
                            Text("Save")
                        }
                    }
                }
                .padding()
            }
        }
    }
}



#Preview {
    EditAccountView(user: User.dummy())
}
