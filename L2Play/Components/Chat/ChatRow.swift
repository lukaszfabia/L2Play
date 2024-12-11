//
//  Row.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/12/2024.
//

import SwiftUI

struct ChatRow: View {
    let authUserID: String
    @StateObject var userViewModel: UserViewModel
    @StateObject var chatViewModel: ChatViewModel
    @State private var chat: Chat? = nil
    
    var body: some View {
        HStack(spacing: 10) {
            if let user = userViewModel.user {
                UserImage(pic: user.profilePicture)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 5) {
                        Text(user.firstName ?? "")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(user.lastName ?? "")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(chat?.messages.last?.text ?? "")
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                }
            } else {
                LoadingView()
            }
            
            Spacer()
            
            Text(chatViewModel.chat?.messages.last?.timestamp.formatTimestamp() ?? "")
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
            loadChatData()
        }
    }
    
    private func loadChatData() {
        chatViewModel.findChat { fetchedChat in
            if let c = fetchedChat {
                chat = c
                
                Task {
                    if let receiverID = userViewModel.getReceiverID(for: chat, currentUserID: authUserID) {
                        await userViewModel.fetchUser(with: receiverID)
                    } else {
                        print("Receiver ID not found")
                    }
                }
            }
        }
    }
}
