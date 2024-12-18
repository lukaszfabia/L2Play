//
//  ChatView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @State private var messageText: String = ""
    
    var body: some View {
        VStack {
            chatHistory
            chatInputBar
        }
        .navigationTitle(chatViewModel.receiver?.fullName() ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: .constant(chatViewModel.errorMessage != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(chatViewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var chatHistory: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(chatViewModel.messages) { message in
                        MessageBubble(message: message, chat: chatViewModel.chat!)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, 10)
            }   
            .onChange(of: chatViewModel.messages) {
                scrollToLastMessage(scrollView)
            }
        }
    }
    
    private func scrollToLastMessage(_ scrollView: ScrollViewProxy) {
        if let lastMessageID = chatViewModel.getLastMessage() {
            DispatchQueue.main.async {
                scrollView.scrollTo(lastMessageID, anchor: .bottom)
            }
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
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    private func sendMessage() {
        Task {
            await chatViewModel.sendMessage(text: messageText)
            
            if chatViewModel.errorMessage == nil {
                HapticManager.shared.generateSuccessFeedback()
            } else {
                HapticManager.shared.generateErrorFeedback()
            }
            
            messageText = ""
        }
    }
}
