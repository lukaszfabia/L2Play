//
//  FollowView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 01/12/2024.
//

import SwiftUI

import Foundation

enum NavBarTitle: String {
    case followers = "Followers"
    case following = "Following"
    case blocked = "Blocked"
}

private struct ListUsersView<ButtonRow: View>: View {
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    var navigationBarTitle: NavBarTitle
    
    @State private var searchText = ""
    var ids: [UUID]
    @State private var users: [User] = []
    
    @ViewBuilder var button: (User) -> ButtonRow
    
    init(navigationBarTitle: NavBarTitle, ids: [UUID], @ViewBuilder button: @escaping (User) -> ButtonRow) {
        self.navigationBarTitle = navigationBarTitle
        self.ids = ids
        self.button = button
    }
    
    var body: some View {
        NavigationStack {
            if users.isEmpty {
                VStack {
                    Text("There is nothing to show here.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("Check back later or try refreshing the page.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                
            } else {
                List(searchResults, id: \.id) { user in
                    NavigationLink(destination: UserView(user: user)) {
                        UserRow(user: user, button: button)
                    }
                }
                .searchable(text: $searchText)
            }
        }
        .navigationTitle(navigationBarTitle.rawValue)
        .onAppear {
            Task {
                users = await userViewModel.getAllWithIds(ids)
            }
        }
    }
    
    var searchResults: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { user in
                user.fullName().localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}



struct BlockedPeopleView: View {
    @EnvironmentObject private var provider: AuthViewModel
    
    var body: some View {
        ListUsersView(navigationBarTitle: .blocked, ids: provider.user.blockedUsers) { user in
            Button(role: .destructive) {
                Task {
                    await provider.toogleBlockUser(user.id)
                }
            } label: {
                Text("Unblock")
            }
        }
    }
}


struct FollowView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @ObservedObject var userViewModel: UserViewModel
    var title: NavBarTitle
    
    private var coll: [UUID] {
        if let user = userViewModel.user {
            title == .followers ? user.followers : user.following
        } else {
            []
        }
    }
    
    init(user: User, title: NavBarTitle) {
        self.userViewModel = UserViewModel(user: user)
        self.title = title
    }
    
    
    var body: some View {
        ListUsersView(navigationBarTitle: title, ids: coll) { user in
            Button(action: {
                Task {
                    await provider.followUser(user)
                }
            }) {
                if title == .following {
                    Text("Unfollow")
                        .font(.headline)
                        .foregroundColor(.primary)
                } else {
                    Text(provider.user.isFollowing(user.id) ? "Following" : "Follow")
                }
            }
            .padding()
            .background(
                Group {
                    if title == .following {
                        Color.red
                    } else if provider.user.isFollowing(user.id) {
                        Color.clear
                    } else {
                        Color.accentColor
                    }
                }
            )
            .cornerRadius(20)
        }
    }
}
