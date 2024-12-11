//
//  ChatListView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/12/2024.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var userViewModels: [String: UserViewModel] = [:]
    @State private var showSearchPpl = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if provider.user.chats.isEmpty {
                    emptyChatView
                } else {
                    chatList
                }
            }
            .onAppear {
                Task {
                    await provider.refreshUser(provider.user)
                }
            }
            .navigationTitle("Chat")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSearchPpl.toggle() }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .refreshable {
                await provider.refreshUser(provider.user)
            }
            .sheet(isPresented: $showSearchPpl) {
                SearchForPplView(uv: UserViewModel(user: provider.user))
            }
        }
    }
    
    private var emptyChatView: some View {
        VStack(spacing: 10) {
            Text("Start Chatting with people!")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            NavigationLink(destination: SearchForPplView(uv: UserViewModel(user: provider.user))) {
                Text("Search for people to talk from your following profiles!")
                    .font(.headline)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private var chatList: some View {
        ScrollView {
            ForEach(provider.user.chats, id: \.self) { id in
                NavigationLink(destination: ChatView(viewModel: ChatViewModel(chatID: id), receiverViewModel: userViewModels[id] ?? createUserViewModel(for: id))) {
                    ChatRow(
                        authUserID: provider.user.id,
                        userViewModel: userViewModels[id] ?? createUserViewModel(for: id),
                        chatViewModel: ChatViewModel(chatID: id)
                    )
                    .padding(.horizontal, 5)
                }
            }
        }
    }
    
    private func createUserViewModel(for chatID: String) -> UserViewModel {
        if let existingViewModel = userViewModels[chatID] {
            return existingViewModel
        }
        let newViewModel = UserViewModel()
        userViewModels[chatID] = newViewModel
        return newViewModel
    }
}
