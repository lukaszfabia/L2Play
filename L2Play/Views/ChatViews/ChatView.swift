//
//  ChatView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @ObservedObject var viewModel: ChatViewModel
    @ObservedObject var receiverViewModel: UserViewModel
    @State private var messageText: String = ""
    
    private func getAuthor(for message: Message, in chat: Chat) -> Author? {
        return chat.participants[message.senderID]
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            if let chat = viewModel.chat {
                                ForEach(chat.messages, id: \.uid) { message in
                                    if let author = getAuthor(for: message, in: chat) {
                                        MessageBubble(
                                            message: message,
                                            isCurrentUser: message.isMe(provider.user.id),
                                            author: author
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                    }.onAppear(){
                        viewModel.observeChatMessages()
                    }
                    .onChange(of: viewModel.chat?.messages.count) {
                        if let lastMessageId = viewModel.chat?.messages.last?.id {
                            DispatchQueue.main.async {
                                scrollView.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            chatInputBar
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
        }
        .navigationTitle(receiverViewModel.user?.fullName() ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage!),
                dismissButton: .default(Text("OK"))
            )
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
        viewModel.sendMessage(text: messageText, senderID: provider.user.id)
        messageText = ""
    }
}
