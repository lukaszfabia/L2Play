//
//  MainView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var provider: AuthViewModel
    @State private var presentSideMenu = false
    @State private var selectedSideMenuTab = 0
    
    var body: some View {
        Group {
            if provider.isLoading {
                LoadingView()
                    .transition(.opacity)
            } else if provider.isAuthenticated {
                AuthenticatedView()
                    .transition(.move(edge: .trailing))
            } else {
                NotLoggedMenu()
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: provider.isLoading)
    }
    
    private func AuthenticatedView() -> some View {
        TabView {
            HomeView(postViewModel: PostViewModel(user: provider.user))
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ChatListView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            UserView(user: provider.user)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                        .foregroundStyle(Color.primary)
                }
            ExploreGamesView(user: provider.user)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
        }
    }
}
