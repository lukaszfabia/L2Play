//
//  ChatListView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/12/2024.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var showSearchPpl = false
    @StateObject private var chatViewModel: ChatViewModel = .init()
    
    @State private var chats: [ChatData] = []
    
    var body: some View {
        NavigationStack {
            Group {
                if provider.isLoading {
                    LoadingView()
                }
                else if let err = chatViewModel.errorMessage {
                    Text(err)
                }
                else if chats.isEmpty {
                    emptyChatView
                } else {
                    chatList
                }
            }.task {
                await loadChats()
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
                await loadChats()
            }
            .sheet(isPresented: $showSearchPpl) {
                SearchForPplView()
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
            
            NavigationLink(destination: SearchForPplView()) {
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
            ForEach(chats) { chat in
                ChatRow(authUser: provider.user, chatData: chat)
            }
        }
    }
    
    private func loadChats() async {
        // get user chats
        // take only participants and
        // detect who is receiver and return Author in the future take last msg
        self.chats = await chatViewModel.fetchChatsData(chatsIDs: provider.user.chats)
    }
    
}
