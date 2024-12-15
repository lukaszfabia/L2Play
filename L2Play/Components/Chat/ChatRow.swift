//
//  Row.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/12/2024.
//

import SwiftUI

struct ChatRow: View {
    let authUser: User
    let chatData: ChatData
    
    var body: some View {
        let user = chatData.getReceiver(authID: authUser.id)! // assert it
        NavigationLink(destination: LazyChatView(authUser: authUser, receiverID: user.id, chatID: chatData.chatID)) {
            HStack (spacing: 10) {
                UserImage(pic: user.profilePicture)
                
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let last = chatData.lastMessage {
                        HStack {
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
            .shadow(radius: 5)
        }
    }
}
