//
//  LazyChatView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 14/12/2024.
//

import SwiftUI

struct LazyChatView: View {
    @StateObject private var receiverViewModel: UserViewModel = .init()
    let authUser: User
    let receiverID: String
    let chatID: String

    
    var body: some View {
        Group {
            if receiverViewModel.isLoading {
                LoadingView()
            } else {
                ChatView(chatViewModel:
                            ChatViewModel(chatID: chatID, sender: authUser, receiver: receiverViewModel.user)
                         )
            }
        }.task {
            await receiverViewModel.fetchUser(with: receiverID)
        }
    }
}

