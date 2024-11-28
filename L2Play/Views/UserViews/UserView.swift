//
//  UserView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI


// TODO: add row with favourite game, playlist row, and reviews in componetnts, right now there is game card as a placeholder

struct UserView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject private var gamesViewModels: GamesViewModel = GamesViewModel()
    
    @State private var favs: [Item] = []
    @State private var playlist: [Game] = []
    @State private var reviews: [Review] = []
    
    @State private var selectedTab = 0
    @State private var isSettingsPresented = false
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ProfileHeaderView(user: provider.user, followSection: {EmptyView()})
                    
                    CustomDivider()
                    
                    Picker(selection: $selectedTab, label: Text("Menu")) {
                        Text("Favourites").tag(0)
                        Text("Playlist").tag(1)
                        Text("My Reviews").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    switch selectedTab {
                    case 0:
                        FavoritesView(favs: $favs)
                        
                    case 1:
                        PlaylistView(playlist: $playlist)
                        
                    case 2:
                        MyReviewsView(reviews: $reviews)
                        
                    default:
                        EmptyView()
                    }
                }
                .padding()
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isSettingsPresented.toggle() }) {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                    }
                }
                .sheet(isPresented: $isSettingsPresented) {
                    SettingsView()
                }
            }
        }
        .onAppear {
            loadData()
        }
        .refreshable {
            loadData()
        }
    }

    private func loadData() {
        Task {
            await provider.refreshUser(provider.user)
            favs =  await gamesViewModels.fetchFavs(user: provider.user)
            playlist = await gamesViewModels.fetchUsersPlaylist(user: provider.user)
//            reviews = await gamesViewModels.fetchReviewsForUser(user: provider.user)
        }
    }
}
