//
//  ChatViewModel.swift
//  L2Play
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import Foundation
import FirebaseDatabase
import Combine

@MainActor
class ChatViewModel: ObservableObject, AsyncOperationHandler {
    private let manager = FirebaseManager()
    private var ref: DatabaseReference!
    private var chatID: String?
    private var observers: [DatabaseHandle] = []
    
    @Published var isLoading: Bool = false
    @Published var chat: Chat?
    @Published var errorMessage: String?
    @Published var messages: [Message] = []
    
    var sender: User? = nil
    var receiver: User? = nil
    
    init(chatID: String? = nil, sender: User? = nil, receiver: User? = nil) {
        self.chatID = chatID
        self.ref = Database.database().reference()
        
        self.sender = sender
        self.receiver = receiver
        
        if let chatID = chatID {
            fetchChat(chatID: chatID)
            listenForMessages()
        } else if let sender, let receiver {
            Task {
                await createNewChat(sender: sender, receiver: receiver)
            }
        }
    }
    
    init() {
        self.ref = Database.database().reference()
    }
    
    deinit {
        DispatchQueue.main.async { [weak self] in
            self?.removeObservers()
        }
    }
    

    var getMessages: [Message] {
        guard let chat else { return [] }
        return chat.messages.reversed()
    }


    func fetchChat(chatID: String) {
        isLoading = true
        let path = ref.child("chats").child(chatID)
        
        path.observeSingleEvent(of: .value) { snapshot in
            self.isLoading = false
            guard let chatData = snapshot.value as? [String: Any] else {
                self.errorMessage = "Failed to load chat data"
                return
            }
            
            if let chat = Chat(from: chatData, chatID: chatID) {
                self.chat = chat
                self.messages = chat.messages
            } else {
                self.errorMessage = "Failed to parse chat data"
            }
        }
    }


    func createNewChat(sender: User, receiver: User) async {
        isLoading = true
        defer { isLoading = false }
        
        let newChatRef = ref.child("chats").childByAutoId()
        guard let chatID = newChatRef.key else {
            self.errorMessage = "Failed to generate chat ID"
            return
        }
        
        let participants: [String: Author] = [
            sender.id: Author(user: sender),
            receiver.id: Author(user: receiver)
        ]
        
        let newChat = Chat(id: chatID, participants: participants, messages: [])
        self.chat = newChat

        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                ref.child("chats").child(newChat.id).setValue(newChat.toDictionary()) { error, _ in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            }
            
            try await manager.updateAll(collection: .users, lst: [sender.addNewChat(chatID: chatID), receiver.addNewChat(chatID: chatID)])
        } catch {
            self.errorMessage = "Failed to create chat: \(error.localizedDescription)"
        }
    }


    func listenForMessages() {
        guard let chat = chat else { return }
        

        let messagesRef = ref.child("chats").child(chat.id).child("messages")
        

        let query = messagesRef.queryOrdered(byChild: "timestamp")
        

        query.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let message = Message(snapshot: snap) {
                    chat.addMessage(message: message)
                    self.messages.append(message)
                }
            }
        }
        

        let addedObserver: DatabaseHandle = query.observe(.childAdded) { snapshot in
            if let newMessage = Message(snapshot: snapshot) {
                chat.addMessage(message: newMessage)
                self.messages.append(newMessage)
            }
        }
        
        observers.append(addedObserver)
    }


    func removeObservers() {
        guard let chat else { return }
        for handle in observers {
            ref.child("chats").child(chat.id).child("messages").removeObserver(withHandle: handle)
        }
        observers.removeAll()
    }

    func sendMessage(text: String) async  {
        guard let sender else {
            errorMessage = "No sender or receiver"
            return
        }
        
        guard let chat = chat else {
            errorMessage = "Chat not initialized"
            return
        }
        
        let messagesRef = ref.child("chats").child(chat.id).child("messages")
        let newMessageRef = messagesRef.childByAutoId()
        
        let message = Message(
            text: text, senderID: sender.id
        )
        
        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                newMessageRef.setValue(message.toDictionary()) { error, _ in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            }
            
            chat.addMessage(message: message)
            self.messages.append(message) 

        } catch {
            self.errorMessage = "Failed to send message: \(error.localizedDescription)"
        }
    }


    func fetchChatsData(chatsIDs: [String], sender: User? = nil) async -> [ChatData] {
        isLoading = true
        defer { isLoading = false }
        
        var chatsData: [ChatData] = []
        
        var idsToRemove: [String] = []
        
        let path = ref.child("chats")
        
        for chatID in chatsIDs {
            do {
                let snapshot = try await path.child(chatID).getData()
                
                guard let dictionary = snapshot.value as? [String: Any] else {
                    throw NSError(domain: "FirebaseError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid chat data for ID: \(chatID)"])
                }

                if let chat = ChatData(from: dictionary, chatID: chatID) {
                    chatsData.append(chat)
                } else {
                    print("Failed to create ChatData for chatID: \(chatID)")
                }
            } catch {
                idsToRemove.append(chatID)
                print("Error fetching data for chatID: \(chatID), Error: \(error.localizedDescription)")
            }
        }
        
        
        // clear chats create during testing 
        if let sender, !chatsIDs.isEmpty {
            let newSender = sender.removeChat(chatID: idsToRemove)
            _ = await performAsyncOperation { [self] in
                try await manager.update(collection: .users, id: newSender.id, object: newSender)
            }
        }
        
        return chatsData
    }

    
    func getLastMessage() -> UUID? {
        guard let chat else { return nil }
        return chat.messages.last?.id
    }
    
    func deleteChat(chatData: ChatData) async {
        self.isLoading = true
        defer {self.isLoading = false}
        
        let chatID = chatData.chatID
        let ids: [String] = chatData.participants.map { $0.key }
        
        let path = ref.child("chats").child(chatID)
        
        _ = await performAsyncOperation { [self] in
            var users: [User] = try await manager.findAll(collection: .users, ids: ids)
            users = users.map({ user in
                user.removeChat(chatID: [chatID])
            })
            
            guard users.count >= 2 else {throw NSError(domain: "Firebase", code: -1, userInfo: nil)}
            
            try await manager.updateAll(collection: .users, lst: users)
            
            try await path.removeValue()
        }
    }
}
