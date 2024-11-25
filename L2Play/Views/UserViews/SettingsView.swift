//
//  Settings.swift
//  ios
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var provider : AuthViewModel
    
    @State private var showDeleteView: Bool = false
    @State private var showLogoutAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                VStack{
                    HStack{
                        UserImage(pic: provider.user.profilePicture, w: 100, h: 100)
                        
                        VStack{
                            HStack{
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
                                    NavigationLink(destination: EditAccountView(user: provider.user)){
                                        HStack {
                                            Image(systemName: "person.crop.circle")
                                                .foregroundColor(.blue)
                                            Text("Edit profile")
                                            
                                        }
                                    }
                                    NavigationLink(destination: BlockedPeopleView(user: provider.user)){
                                        HStack {
                                            Image(systemName: "nosign")
                                                .foregroundColor(.red)
                                            Text("Blocked users")
                                        }
                                    }
                                    
                                    // TODO: add change languague 
                                }
                            
                            Section(header: Text("Actions")
                                .font(.headline)
                                .foregroundColor(.primary)) {
                                    Button(action: {showLogoutAlert.toggle()}){
                                        HStack {
                                            Image(systemName: "arrow.right.square")
                                                .foregroundColor(.yellow)
                                            Text("Logout")
                                                .foregroundColor(.yellow)
                                        }
                                    }.alert(isPresented: $showLogoutAlert) {
                                        Alert(
                                            title: Text("Are you sure to logout?"),
                                            message: Text("You will be redirected to the login page"),
                                            primaryButton: .default(Text("Logout")) {
                                                provider.logout()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    Button(action: {showDeleteView.toggle()}){
                                        HStack {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                            Text("Remove account")
                                                .foregroundColor(.red)
                                        }
                                    }.sheet(isPresented: $showDeleteView, content: {DeleteAccountView()})
                                }
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                    .cornerRadius(10)
                    .navigationTitle("Settings")
                }
            }.padding()
        }
    }
}

#Preview{
    SettingsView()
        .environmentObject(AuthViewModel(
            isAuthenticated: true, user: User.dummy()
        ))
}
