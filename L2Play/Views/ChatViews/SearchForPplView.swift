//
//  SearchForPpl.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/12/2024.
//

import SwiftUI

struct SearchForPplView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var filteredProfiles: [User] = []
    @State private var profiles: [User] = []
    @State private var searchedText: String = ""
    @State private var selectedChat: ChatData? = nil
    
    @StateObject private var chatViewModel: ChatViewModel = .init()
    @StateObject private var userViewModel: UserViewModel = .init()
    
    @State private var choosenOne: User?
    
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if userViewModel.isLoading {
                    LoadingView()
                } else if profiles.isEmpty {
                    Text("No people to chat")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                } else {
                    List(filteredProfiles) { profile in
                        Button {
                            createOrSelectChat(with: profile)
             
                            path.append(profile.id)
                        } label: {
                            userRow(profile: profile)
                        }
                    }
                    .searchable(text: $searchedText, prompt: "Search for people...")
                    .onChange(of: searchedText) {
                        filterProfiles()
                    }
                }
            }
            .task {
                profiles = await userViewModel.getAll(authUser: provider.user)
                filterProfiles()
            }
            .navigationTitle("Start Chatting")
            .navigationBarTitleDisplayMode(.inline)

            // TODO: Fix it infinite loop
            .navigationDestination(for: String.self) { profileID in
                if let profile = filteredProfiles.first(where: { $0.id == profileID }),
                   let chat = selectedChat {
                    LazyChatView(
                        authUser: provider.user,
                        receiverID: profile.id,
                        chatID: chat.chatID)
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    private func filterProfiles() {
        if searchedText.isEmpty {
            filteredProfiles = profiles
        } else {
            filteredProfiles = profiles.filter({
                $0.fullName().lowercased().contains(searchedText.lowercased())
            })
        }
    }
    
    private func userRow(profile: User) -> some View {
        HStack(spacing: 20) {
            UserImage(pic: profile.profilePicture, initial: profile.fullName(), w: 40, h: 40)
            HStack(spacing: 10) {
                Text(profile.fullName())
                    .font(.headline)
                
                if profile.isFollowing(provider.user.id) {
                    Text("Follows you")
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .foregroundColor(.primary)
                        .font(.footnote)
                }
            }
            Spacer()
        }
    }
    
    private func createOrSelectChat(with profile: User) {
        var chats: [ChatData] = []
        

        Task {
            self.choosenOne = profile
            chats = await chatViewModel.fetchChatsData(chatsIDs: provider.user.chats)
            for chat in chats{
                print(chat.participants)
            }

            if let selectedChat = chats.first(where: { $0.participants[profile.id] != nil }) {
                self.selectedChat = selectedChat
            } else {
                await chatViewModel.createNewChat(sender: provider.user, receiver: profile)
                await provider.refreshUser(provider.user)
            }
        }
    }
}
