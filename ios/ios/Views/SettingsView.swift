//
//  Settings.swift
//  ios
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var provider : AuthProvider
    @State var user: User = User.dummy()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            AsyncImage(url: user.profilePicture) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .shadow(radius: 12)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        VStack{
                            HStack{
                                Text(user.firstName)
                                    .font(.title2)
                                    .bold()
                                
                                Text(user.lastName)
                                    .font(.title2)
                                    .foregroundStyle(Color.secondary)
                            }
                            
                            Text(user.email)
                                .foregroundStyle(.blue)
                        }.padding(.horizontal, 10)
                    }
                    
                    CustomDivider().padding()
                    
                    
                    VStack {
                        List {
                            Section(header: Text("Account")
                                .font(.headline)
                                .foregroundColor(.primary)) {
                                    NavigationLink(destination: EditAccountView()){
                                        HStack {
                                            Image(systemName: "person.crop.circle")
                                                .foregroundColor(.blue)
                                            Text("Manage account")
                                            
                                        }
                                    }
                                    NavigationLink(destination: BlockedPeopleView()){
                                        HStack {
                                            Image(systemName: "nosign")
                                                .foregroundColor(.red)
                                            Text("Blocked people")
                                        }
                                    }
                                }
                            
                            Section(header: Text("Actions")
                                .font(.headline)
                                .foregroundColor(.primary)) {
                                    HStack {
                                        Image(systemName: "arrow.right.square")
                                            .foregroundColor(.yellow)
                                        Text("Log out")
                                            .foregroundColor(.yellow)
                                    }
                                    Button(action: {}){
                                        HStack {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                            Text("Remove account")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                    .cornerRadius(10)
                    .shadow(radius: 20)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }.padding()
        }.onAppear{
            self.user = provider.user!
        }
    }
    
    
    private func removeAcc() {
        
    }
    
    
}

#Preview{
    SettingsView()
        .environmentObject(AuthProvider(
            isAuthenticated: true, tokens: Tokens.dummy(), user: User.dummy()
        ))
}
