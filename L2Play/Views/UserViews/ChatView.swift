//
//  ChatView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI


struct SearchForPplView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @State private var filteredProfiles: [User] = []
    @State private var profiles: [User] = []
    @State private var searchedText: String = ""
    @State private var selectedChat: Chat? = nil
    @ObservedObject var uv: UserViewModel
    
    var body: some View {
        VStack {
            if profiles.isEmpty {
                Text("Loading users...")
            } else {
                List(filteredProfiles) { profile in
                    Button {
                        createOrSelectChat(with: profile)
                    } label: {
                        userRow(profile: profile)
                    }
                }
                .searchable(text: $searchedText, prompt: "Search for people...")
                .onChange(of: searchedText) {
                    filterProfiles()
                }

                if let chat = selectedChat {
                    NavigationLink(destination: ChatView(viewModel: ChatViewModel(chatID: chat.id))) {
                        EmptyView()
                    }
                }
            }
        }
        .navigationTitle("Start Chatting")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                profiles = await uv.getAllWithIds(provider.user.following)
                filterProfiles()
            }
        }
    }
    
    private func filterProfiles() {
        if searchedText.isEmpty {
            filteredProfiles = profiles
        } else {
            filteredProfiles = profiles.filter({
                $0.fullName().lowercased().contains(searchedText.lowercased())
            })
        }
    }
    
    private func userRow(profile: User) -> some View {
        HStack(spacing: 20) {
            UserImage(pic: profile.profilePicture, w: 40, h: 40)
            VStack(alignment: .leading, spacing: 10) {
                Text(profile.fullName())
                    .font(.headline)
                
                if profile.isFollowing(provider.user.id) {
                    Text("Follows you")
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .foregroundColor(.primary)
                }
            }
            Spacer()
        }
    }
    
    private func createOrSelectChat(with profile: User) {
        let participants = [
            provider.user.id: Author(user: provider.user),
            profile.id: Author(user: profile)
        ]
        
        ChatViewModel().findOrCreateChat(participants: participants) { chat in
            if let chat = chat {
                selectedChat = chat
            }
        }
    }
}


struct ChatListView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @StateObject private var userViewModel = UserViewModel()
    @State private var showSearchPpl = false
    
    var body: some View {
        NavigationStack {
            if provider.user.chats.isEmpty {
                emptyChatView
            } else {
                chatList
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
        .sheet(isPresented: $showSearchPpl) {
            SearchForPplView(uv: userViewModel)
        }
    }
    
    private var emptyChatView: some View {
        VStack(spacing: 10) {
            Text("Start Chatting with people!")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            NavigationLink(destination: SearchForPplView(uv: userViewModel)) {
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
        LazyVStack {
            List(provider.user.chats, id: \.self) { id in
                Text(id)
            }
        }
    }
}


struct ChatRow: View {
    @State var chat: Chat
    @ObservedObject var userViewModel: UserViewModel
    @State var currID: String
    
    var body: some View {
        HStack(spacing: 15) {
            if let user = userViewModel.user {
                UserImage(pic: user.profilePicture)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.fullName())
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(chat.messages.last?.text ?? "No messages")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                
                Text(chat.lastMessageTimestamp.formatTimestamp())
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(chat.lastMessageTimestamp.formatTimestamp())
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
                await userViewModel.fetchUser(with:
                                                userViewModel.getReceiverID(for: chat, currentUserID: currID))
            }
        }
    }
}

struct ChatView: View {
    @EnvironmentObject private var provider: AuthViewModel
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""
    
    private func getAuthor(for message: Message, in chat: Chat) -> Author? {
        guard let author = chat.participants[message.senderID.uuidString] else {
            return nil
        }
        return author
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                Text("JHFBSHKDFBSDKJFBSDKJFSD")
//                ScrollViewReader { scrollView in
//                    ScrollView {
//                        LazyVStack(alignment: .leading, spacing: 8) {
//                            if let chat = viewModel.chat {
//                                ForEach(chat.messages, id: \.id) { message in
//                                    if let author = getAuthor(for: message, in: chat) {
//                                        MessageBubble(
//                                            message: message,
//                                            isCurrentUser: message.isMe(provider.user.id),
//                                            author: author
//                                        )
//                                    }
//                                }
//                            }
//                        }
//                        .padding()
//                    }
//                    .onChange(of: viewModel.chat?.messages.count) { _ in
//                        scrollToBottom(scrollView)
//                    }
//                }
            }
            
            chatInputBar
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
        }
        .navigationTitle("Chat")
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
    
    private func scrollToBottom(_ scrollView: ScrollViewProxy) {
        if let lastMessageId = viewModel.chat?.messages.last?.id {
            DispatchQueue.main.async {
                scrollView.scrollTo(lastMessageId, anchor: .bottom)
            }
        }
    }
}
