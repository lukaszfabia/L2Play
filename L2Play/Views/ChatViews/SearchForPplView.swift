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
    @State private var selectedChat: Chat? = nil
    @ObservedObject var uv: UserViewModel
    
    var body: some View {
        VStack {
            if profiles.isEmpty {
                LoadingView()
            } else {
                List(filteredProfiles) { profile in
                    Button {
                        createOrSelectChat(with: profile)
                    } label: {
                        userRow(profile: profile)
                    }
                }
                .searchable(text: $searchedText, prompt: "Search for people...")
                .onChange(of: searchedText) {
                    //                    DispatchQueue.main.async {
                    filterProfiles()
                    //                    }
                }
                
                
                if let chat = selectedChat {
                    NavigationLink(destination: ChatView(viewModel: ChatViewModel(chatID: chat.id), receiverViewModel: uv)) {
                        EmptyView()
                    }
                }
            }
        }
        .navigationTitle("Start Chatting")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                profiles = await uv.getAllWithIds(provider.user.following)
                filterProfiles()
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
            UserImage(pic: profile.profilePicture, w: 40, h: 40)
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
        let participants = [
            provider.user.id: Author(user: provider.user),
            profile.id: Author(user: profile)
        ]
        
        ChatViewModel().findOrCreateChat(participants: participants) { chat in
            if let chat = chat {
                selectedChat = chat
            }
        }
    }
}


