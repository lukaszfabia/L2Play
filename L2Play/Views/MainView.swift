//
//  MainView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI

struct HomeView: View {
    // TODO: implement home view, like Twitter or github has
    var body: some View {
        Text("glowna")
    }
}

struct MainView: View {
    @EnvironmentObject var provider: AuthViewModel
    @State private var presentSideMenu = false
    @State private var selectedSideMenuTab = 0
    
    var body: some View {
        if provider.isAuthenticated, let user = provider.user {
            TabView{
                HomeView()
                    .tabItem(){
                        Image(systemName: "house")
                        Text("Home")
                    }
                ChatView()
                    .tabItem(){
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                UserView(user: user)
                    .tabItem(){
                        Image(systemName: "person.fill")
                        Text("Profile")
                            .foregroundStyle(Color.primary)
                }
                ExploreGamesView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Explore")
                    }
            }
        } else {
            NotLoggedMenu()
        }
    }
}


#Preview {
    MainView()
        .environmentObject(AuthViewModel(isAuthenticated: true, user: .dummy()))
}
