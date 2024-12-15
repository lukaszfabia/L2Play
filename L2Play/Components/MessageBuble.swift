//
//  MessageBuble.swift
//  L2Play
//
//  Created by Lukasz Fabia on 05/12/2024.
//

import SwiftUI

struct MessageBubble: View {
    @EnvironmentObject private var provider: AuthViewModel
    let message: Message
    let chat: Chat
    
    var body: some View {
        if let author = getAuthor(for: message, in: chat) {
            HStack {
                if !isCurrentUser() {
                    UserImage(pic: author.profilePicture, w: 30, h: 30)
                }
                if isCurrentUser() {
                    Spacer()
                }
                
                VStack(alignment: isCurrentUser() ? .trailing : .leading, spacing: 4) {
                    Text(message.text)
                        .padding()
                        .background(isCurrentUser() ? Color.accentColor : Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                        .frame(maxWidth: 250, alignment: isCurrentUser() ? .trailing : .leading)
                    
                    Text(message.timestamp.formatTimestamp())
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if isCurrentUser() {
                    UserImage(pic: author.profilePicture, w: 30, h: 30)
                }
                if !isCurrentUser() {
                    Spacer()
                }
            }
            .padding(.vertical, 4)
            .padding(isCurrentUser() ? .leading : .trailing, 60)
        }
    }
    
    private func isCurrentUser() -> Bool {
        return message.isMe(provider.user.id)
    }
    
    private func getAuthor(for message: Message, in chat: Chat) -> Author? {
        return chat.participants[message.senderID]
    }
}
