//
//  UserView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI
struct UserView: View {
    @EnvironmentObject private var provider: AuthViewModel // for me
    @StateObject private var gamesViewModel: GamesViewModel = GamesViewModel()
    @StateObject private var userViewModel: UserViewModel

    @State private var favs: [Item] = []
    @State private var playlist: [Game] = []
    @State private var reviews: [Review] = []

    @State private var selectedTab = 0
    @State private var isSettingsPresented = false
    @State private var showErrorAlert = false
    
    init(user: User?) {
        print("Czy to sie wykona")
        self._userViewModel = StateObject(wrappedValue: UserViewModel(user: user))
    }

    private var currentUser: User {
        userViewModel.user ?? provider.user 
    }
    
    private var isReadOnly: Bool {
        !(userViewModel.isAuth(provider.user.email))
    }

    var body: some View {
        NavigationStack {
            if provider.isLoading || gamesViewModel.isLoading {
                LoadingView()
            } else if let err = provider.errorMessage ?? gamesViewModel.errorMessage {
                Text(err)
            } else {
                ScrollView(.vertical) {
                    VStack {
                        ProfileHeaderView(user: currentUser, followSection: followButtonIfNeeded)
                        
                        CustomDivider()
                        
                        Picker(selection: $selectedTab, label: Text("Menu")) {
                            Text("Favourites").tag(0)
                            Text("Playlist").tag(1)
                            if !isReadOnly {
                                Text("My Reviews").tag(2)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        switch selectedTab {
                        case 0:
                            FavoritesView(favs: $favs)
                        case 1:
                            PlaylistView(playlist: $playlist)
                        case 2:
                            if !isReadOnly {
                                MyReviewsView(reviews: $reviews)
                            } else {
                                EmptyView()
                            }
                        default:
                            EmptyView()
                        }
                    }
                    .padding()
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        if !isReadOnly {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { isSettingsPresented.toggle() }) {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $isSettingsPresented) {
                        SettingsView()
                    }
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Error"), message: Text(provider.errorMessage ?? gamesViewModel.errorMessage ?? "An unknown error occurred"), dismissButton: .default(Text("OK")))
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
    }

    @ViewBuilder
    private func followButtonIfNeeded() -> some View {
        if isReadOnly {
            Button(action: {
                Task {
                    await provider.followUser(currentUser)
                }
            }) {
                Text(userViewModel.isFollowed(by: provider.user) == true ? "Following" : "Follow")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 30)
            .background(userViewModel.isFollowed(by: provider.user) == true ? Color.clear : Color.accentColor)
            .cornerRadius(20)
        }
    }

    private func loadData() {
        guard !provider.isLoading && !gamesViewModel.isLoading else { return }

        Task {
            await userViewModel.refreshUser()
            favs = await gamesViewModel.fetchFavs(user: currentUser)
            playlist = await gamesViewModel.fetchUsersPlaylist(user: currentUser)
        }
    }
}
