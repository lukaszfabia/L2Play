//
//  Settings.swift
//  ios
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI

struct SettingsView: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        AsyncImage(url: user.profile_picture) { image in
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
                            Text(user.first_name)
                                .font(.title2)
                                .bold()
                            
                            Text(user.last_name)
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
                                HStack {
                                    Image(systemName: "person.crop.circle")
                                        .foregroundColor(.blue)
                                    Text("Manage account")
                                }
                                HStack {
                                    Image(systemName: "person.2")
                                        .foregroundColor(.blue)
                                    Text("Blocked people")
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
                                HStack {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                    Text("Remove account")
                                        .foregroundColor(.red)
                                }
                            }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                .cornerRadius(10)
                .shadow(radius: 20)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }.padding()
    }
}

#Preview{
    let url: URL = URL(string: "https://placebeard.it/250/250")!
    
    let user: User = User(
        first_name: "Lukasz",
        last_name: "Fabia",
        email: "ufabia03@gmail.com",
        profile_picture: url,
        friends: [],
        friend_requests: [],
        created_at: Date()
    )
    
    SettingsView(user: user)
}
