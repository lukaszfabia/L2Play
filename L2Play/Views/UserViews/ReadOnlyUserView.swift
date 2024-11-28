//
//  ReadOnlyUser.swift
//  ios
//
//  Created by Lukasz Fabia on 10/10/2024.
//

import SwiftUI

// TODO: implement other user, we can consider to extract some functions (treat them like a compotents) from profile and build to different views related with user


struct ReadOnlyUserView: View {
    var email : String
    
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject private var gamesViewModels: GamesViewModel = GamesViewModel()
    
    @State private var favs: [Item] = []
    @State private var playlist: [Game] = []
    @State private var reviews: [Review] = []
    
    @State private var selectedTab = 0
    @State private var isSettingsPresented = false
    
    var body: some View {
        if userViewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        } else if let user = userViewModel.user {
            NavigationStack {
                ScrollView(.vertical) {
                    VStack {
                        ProfileHeaderView(user: user, followSection: {
                            Button(action: {
                                Task {
                                    await provider.followUser(user)
                                }
                            }) {
                                Text(userViewModel.isFollowed(provider.user) ? "Following" : "Follow")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .backgroundStyle(userViewModel.isFollowed(provider.user) ?
                                             Color.clear : Color.accentColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(userViewModel.isFollowed(provider.user) ? Color.accentColor : Color.clear, lineWidth: 2)
                            )
                            .frame(width: 200)
                            .cornerRadius(20)
                        })
                        
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
                }
            }
            .onAppear {
                loadData()
            }
            .refreshable {
                loadData()
            }
        } else if let errorMessage = userViewModel.errorMessage {
            Text("Error: \(errorMessage)")
        }
    }
    
    private func loadData() {
        Task {
            
            await userViewModel.fetchUserByEmail(email)
//            favs = await gamesViewModels.fetchFavs(user: provider.user)
//            playlist = await gamesViewModels.fetchUsersPlaylist(user: provider.user)
//            reviews = await gamesViewModels.fetchReviewsForUser(user: provider.user)
        }
    }
}
