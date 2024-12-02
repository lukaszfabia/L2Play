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
                        ProfileHeaderView(user: currentUser, actionSection: actionButtons)
                        
                        CustomDivider()
                        
                        if isReadOnly {
                            if currentUser.hasBlocked(provider.user.id) {
                                youreBlocked()
                            } else if provider.user.hasBlocked(currentUser.id) {
                                youBlockedUser()
                            }
                        }

                        
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
                        } else {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Menu {
                                    Button(action: {
                                        // init new or take existing chat
                                    }) {
                                        Label("Send Message", systemImage: "paperplane.fill")
                                    }
                                    
                                    Button(role: .destructive, action: {
                                        Task {
                                            var u = currentUser
                                            await provider.toogleBlockUser(&u)
                                            
                                            if provider.errorMessage != nil {
                                                HapticManager.shared.generateErrorFeedback()
                                            } else {
                                                HapticManager.shared.generateSuccessFeedback()
                                            }
                                        }
                                    }) {
                                        Label(provider.user.hasBlocked(currentUser.id) ? "Unblock" : "Block \(currentUser.firstName ?? "User")", systemImage: "hand.raised.fill")
                                            .foregroundColor(.red)
                                    }
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .font(.title3)
                                        .foregroundColor(.primary)
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
    
    private func youBlockedUser() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "hand.raised.fill")
                .foregroundColor(.red)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text("\(currentUser.firstName ?? "") is blocked.")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("You've blocked \(currentUser.firstName ?? ""). You can always unblock them.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                NavigationLink(destination: BlockedPeopleView()) {
                    Text("Your blocked users")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.1))
        )
        .padding(.vertical, 8)
    }
    
    private func youreBlocked() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "hand.raised.fill")
                .foregroundColor(.red)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text("Blocked")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("You've been blocked by \(currentUser.firstName ?? "").")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.1))
        )
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func actionButtons() -> some View {
        if isReadOnly {
            HStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    Task {
                        await provider.followUser(currentUser)
                    }
                }) {
                    Text(provider.user.isFollowing(currentUser.id) ? "Unfollow" : "Follow")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 150, height: 40)
                .background(provider.user.isFollowing(currentUser.id) ? Color.red : Color.accentColor)
                .cornerRadius(20)
                .disabled(currentUser.hasBlocked(provider.user.id))
            }
            .padding([.vertical, .horizontal], 5)
        }
    }

    private func loadData() {
        guard !provider.isLoading && !gamesViewModel.isLoading else { return }

        Task {
            await userViewModel.refreshUser()
            favs = await gamesViewModel.fetchFavs(user: currentUser)
            playlist = await gamesViewModel.fetchUsersPlaylist(user: currentUser)
            reviews = await userViewModel.fetchReviewsForUser(user: currentUser)
        }
    }
}
