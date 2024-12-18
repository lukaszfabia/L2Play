//
//  ChatRow.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/12/2024.
//

import SwiftUI

struct ChatRow: View {
    let authUser: User
    let chatData: ChatData
    let onDelete: (ChatData) async -> Void
    
    @State private var isShowingDeleteAlert = false // Dla alertu potwierdzającego usunięcie
    
    var body: some View {
        let user = chatData.getReceiver(authID: authUser.id)!
        
        NavigationLink(destination: LazyChatView(authUser: authUser, receiverID: user.id, chatID: chatData.chatID)) {
            HStack(spacing: 10) {
                UserImage(pic: user.profilePicture, initial: user.name)
                
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let last = chatData.lastMessage {
                        HStack(spacing: 0) {
                            if last.isMe(authUser.id) {
                                Text("You: ")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("\(chatData.getReceiver(authID: authUser.id)!.name): ")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(last.text)
                                .font(.subheadline)
                                .lineLimit(1)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("Send first message!")
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundStyle(.yellow)
                    }
                }
                
                Spacer()
                
                if let last = chatData.lastMessage {
                    Text(last.timestamp.formatTimestamp())
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    isShowingDeleteAlert = true
                }
        )
        .alert("Delete Chat", isPresented: $isShowingDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task {
                    await onDelete(chatData)
                    HapticManager.shared.generateHapticFeedback(style: .medium)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this chat?")
        }
    }
}
