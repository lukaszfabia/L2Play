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
    HomeView()
        .environmentObject(AuthProvider(isAuthenticated: true, tokens: nil, user: User.dummy()))
}
