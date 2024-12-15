//
//  Settings.swift
//  ios
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @EnvironmentObject private var settingsHandler: SettingsHandler
    @State private var showDeleteView: Bool = false
    @State private var showLogoutAlert: Bool = false
    @Binding var isSettingsPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        UserImage(pic: provider.user.profilePicture, w: 100, h: 100)
                        
                        VStack {
                            HStack {
                                Text(provider.user.firstName ?? "unknown")
                                    .font(.title2)
                                    .bold()
                                
                                Text(provider.user.lastName ?? "user")
                                    .font(.title2)
                                    .foregroundStyle(Color.secondary)
                            }
                            
                            Text(provider.user.email)
                                .foregroundStyle(.blue)
                        }.padding(.horizontal, 10)
                    }
                    
                    CustomDivider().padding()
                    
                    VStack {
                        List {
                            Section(header: Text("Account")
                                .font(.headline)
                                .foregroundColor(.primary)) {
                                    NavigationLink(destination: EditAccountView(isSettingsPresented: $isSettingsPresented)) {
                                        HStack {
                                            Image(systemName: "person.crop.circle")
                                                .foregroundColor(.blue)
                                            Text("Edit profile")
                                        }
                                    }
                                    NavigationLink(destination: BlockedPeopleView()) {
                                        HStack {
                                            Image(systemName: "nosign")
                                                .foregroundColor(.red)
                                            Text("Blocked users")
                                        }
                                    }
                                }
                            
                            Section(header: Text("Appearance")
                                .font(.headline)
                                .foregroundColor(.primary)) {
                                    Toggle(isOn: $settingsHandler.isDarkMode) {
                                        Text("Dark Mode")
                                    }
                                }
                            
                            Section(header: Text("Language")
                                .font(.headline)
                                .foregroundColor(.primary)) {
                                    Picker("Change Language", selection: $settingsHandler.language) {
                                        ForEach([Language.english, Language.polish], id: \.self) { lang in
                                            Text(lang.rawValue)
                                                .tag(lang.rawValue)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                            
                            Section(header: Text("Actions")
                                .font(.headline)
                                .foregroundColor(.primary)) {
                                    Button(action: { showLogoutAlert.toggle() }) {
                                        HStack {
                                            Image(systemName: "arrow.right.square")
                                                .foregroundColor(.yellow)
                                            Text("Logout")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    .alert(isPresented: $showLogoutAlert) {
                                        Alert(
                                            title: Text("Are you sure to logout?"),
                                            message: Text("You will be redirected to the login page"),
                                            primaryButton: .default(Text("Logout")) {
                                                provider.logout()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    
                                    Button(action: { showDeleteView.toggle() }) {
                                        HStack {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                            Text("Remove account")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .sheet(isPresented: $showDeleteView, content: { DeleteAccountView() })
                                }
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                    .cornerRadius(10)
                    .navigationTitle("greeting".localized(with: provider.user.firstName ?? ""))
                    .preferredColorScheme(settingsHandler.currentTheme())
                }
            }
            .padding()
        }
    }
}
