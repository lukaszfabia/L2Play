//
//  UserView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject private var provider: AuthViewModel // for me
    @StateObject private var userViewModel: UserViewModel
    
    @State private var favs: [Item] = []
    @State private var reviews: [Review] = []
    
    @State private var selectedTab = 0
    @State private var isSettingsPresented = false
    @State private var showErrorAlert = false
    
    @State private var triedToFetch: Bool = false
    
    init(user: User?) {
        self._userViewModel = StateObject(wrappedValue: UserViewModel(user: user))
    }
    
    private var currentUser: User {
        userViewModel.user ?? provider.user
    }
    
    private var isReadOnly: Bool {
        userViewModel.user != provider.user
    }
    
    var body: some View {
        NavigationStack {
            if reviews.isEmpty && !triedToFetch {
                LoadingView().task {
                    await loadData()
                }
            } else if let err = userViewModel.errorMessage {
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
                            FavoritesView(favs: $favs, userViewModel: UserViewModel(user: provider.user))
                        case 1:
                            PlaylistView(userViewModel: UserViewModel(user: provider.user))
                        case 2:
                            if !isReadOnly {
                                MyReviewsView(reviews: $reviews)
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
                        SettingsView(isSettingsPresented: $isSettingsPresented)
                    }
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Error"), message: Text(userViewModel.errorMessage ?? "An unknown error occurred"), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
        .refreshable {
            await loadData()
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
    
    private func loadData() async {
        guard !userViewModel.isLoading else { return }
        
        triedToFetch = true 
        
        await userViewModel.refreshUser()
        reviews = await userViewModel.fetchReviewsForUser(user: currentUser)
        
        DispatchQueue.main.async {
            // split games by state
            let dict = currentUser.splitByState()
            
            favs = dict[GameState.favorite]?.map { game in
                Item(game: game)
            } ?? []
        }
    }
}
