//
//  ProfileView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var provider: AuthProvider
    @State private var presentSideMenu = false
    @State private var selectedSideMenuTab = 0
    
    var body: some View {
        if provider.isAuthenticated, let user = provider.user {
            TabView{
                ChatView()
                    .tabItem(){
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                FriendsView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Friends")
                    }
                UserView(user: user)
                    .tabItem(){
                        Image(systemName: "person.fill")
                        Text("Profile")
                            .foregroundStyle(Color.primary)
                }
                SettingsView(user: user)
                    .tabItem(){
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        } else {
            NotLoggedMenu()
        }
    }
}


#Preview {
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
    
    HomeView()
        .environmentObject(AuthProvider(isAuthenticated: true, tokens: nil, user: user))
}
