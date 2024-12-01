//
//  ChatView.swift
//  ios
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI

private func getReceiverID(currUserID: String?, chat: Chat) -> String? {
    guard let currUserID else {return nil}
    
    for (userID, _) in chat.participants where userID != currUserID {
        return userID
    }
    return nil
}

private func formatTimestamp(_ timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

struct ChatListView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject private var userViewModel: UserViewModel = UserViewModel()
    
    @State private var chats: [Chat] = []
    
    var body: some View {
        NavigationStack {
            if !chats.isEmpty {
                LazyVStack {
                    ForEach(chats, id: \.id) { chat in
                        NavigationLink(destination: ChatView(viewModel: ChatViewModel(chatID: chat.id))) {
                            ChatRow(chat: chat, userViewModel: userViewModel, currUserID: provider.currentUserUUID)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            } else {
                VStack(spacing: 10) {
                    Text("Start Chatting with people!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Text("Discover new conversations and connect with players!")
                        .font(.subheadline)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    NavigationLink(destination: ExploreGamesView(), label: {
                        Text("Explore Games and Join Now")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    })
                }.padding()
            }
        }
        .navigationTitle("Chat")
        .onAppear() {
            provider.listUserChats()
            chats = provider.chats
        }
        .refreshable {
            provider.listUserChats()
            chats = provider.chats
        }
    }
}

struct ChatRow: View {
    @State var chat: Chat
    @ObservedObject var userViewModel: UserViewModel
    @State private var user: User?
    @State var currUserID: String?
    
    var body: some View {
        HStack(spacing: 15) {
            UserImage(pic: user?.profilePicture)
            
            VStack(alignment: .leading, spacing: 8) {
                if let user, let firstName = user.firstName, let lastName = user.lastName {
                    Text("\(firstName) \(lastName)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(chat.messages.last?.text ?? "No messages")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                
                Text(formatTimestamp(chat.lastMessageTimestamp))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(formatTimestamp(chat.lastMessageTimestamp))
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.trailing, 10)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            Task {
                user = await userViewModel.getUserByID(
                    getReceiverID(currUserID: currUserID, chat: chat)
                )
            }
        }
    }
}

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""
    @EnvironmentObject private var provider: AuthViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.chat?.messages ?? [], id: \.id) { message in
                                MessageBubble(message: message, isCurrentUser: message.senderId == provider.user.id.uuidString)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.chat?.messages.count) {
                        scrollToBottom(scrollView)
                    }
                }
            }
            
            chatInputBar
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var chatInputBar: some View {
        HStack {
            TextField("Enter your message", text: $messageText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .cornerRadius(20)
                .shadow(radius: 1)
                .padding(.horizontal, 4)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(messageText.isEmpty ? .gray : .accentColor)
                    .padding(10)
            }
            .disabled(messageText.isEmpty)
        }
    }
    
    private func sendMessage() {
        viewModel.sendMessage(text: messageText, senderId: provider.user.id.uuidString)
        messageText = ""
    }
    
    private func scrollToBottom(_ scrollView: ScrollViewProxy) {
        if let lastMessageId = viewModel.chat?.messages.last?.id {
            DispatchQueue.main.async {
                scrollView.scrollTo(lastMessageId, anchor: .bottom)
            }
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding()
                    .background(isCurrentUser ? Color.accentColor : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .cornerRadius(12)
                    .frame(maxWidth: 250, alignment: isCurrentUser ? .trailing : .leading)
                
                Text(formatTimestamp(message.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if !isCurrentUser { Spacer() }
        }
        .padding(isCurrentUser ? .leading : .trailing, 60)
        .padding(.vertical, 4)
    }
    
    private func formatTimestamp(_ timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

