import Foundation
import FirebaseDatabase
import Combine

class ChatViewModel: ObservableObject, AsyncOperationHandler {
    private let manager = FirebaseManager()
    
    private var ref: DatabaseReference!
    private var chatID: String?
    
    @Published var isLoading: Bool = false
    @Published var chat: Chat? = nil
    @Published var errorMessage: String?
    
    init(chatID: String?) {
        self.chatID = chatID
        self.ref = Database.database().reference()
        
        if let chatID = chatID {
            listenForMessages(chatID: chatID)
        }
    }
    
    init() {
        self.ref = Database.database().reference()
    }
    
    func findOrCreateChat(participants: [String: Author], completion: @escaping (Chat?) -> Void) {
        self.isLoading = true
        defer {self.isLoading = false}
        let chatsRef = ref.child("chats")
        
        chatsRef.observeSingleEvent(of: .value) { snapshot in
            
            if let existingChatSnapshot = snapshot.children.allObjects.first(where: { snap in
                guard let snap = snap as? DataSnapshot,
                      let chatData = snap.value as? [String: Any],
                      let chatParticipants = chatData["participants"] as? [String: Any] else {
                    return false
                }
                
                
                return Set(chatParticipants.keys) == Set(participants.keys)
            }) as? DataSnapshot {
                let chat = self.recreateChat(from: existingChatSnapshot)
                self.chatID = chat?.id
                completion(chat)
            } else {
                self.createChat(participants: participants) { newChat in
                    
                    Task {
                        await self.appendChatToUsers(lhs: Array(participants.keys)[0], rhs: Array(participants.keys)[1], chatID: newChat?.id ?? "")
                    }
                    completion(newChat)
                }
            }
        }
    }
    
    private func createChat(participants: [String: Author], completion: @escaping (Chat?) -> Void) {
        let chatsRef = ref.child("chats").childByAutoId()
        let chatrefID = chatsRef.key! // lets assert it
        
        let chatData: [String: Any] = [
            "participants": participants.mapValues { author in
                [
                    "name": author.name,
                    "profilePicture": author.profilePicture?.absoluteString ?? "",
                    "id": author.id
                ]
            },
            "messages": []
        ]
        
        print("Attempting to create a new chat with data:", chatData)
        
        chatsRef.setValue(chatData) { [weak self] error, _ in
            guard let self = self else { return }
            if let error = error {
                print("Error during chat creation:", error.localizedDescription)
                self.errorMessage = "Failed to create chat: \(error.localizedDescription)"
                completion(nil)
            } else {
                self.chat = Chat(id: chatrefID, participants: participants, messages: [])
                completion(self.chat)
                self.listenForMessages(chatID: chatrefID)
            }
        }
    }
    
    func sendMessage(text: String, senderID: String) {
        guard let chatID = chatID else {
            errorMessage = "No chat available to send message."
            return
        }

        self.isLoading = true
        let messagesRef = ref.child("chats").child(chatID).child("messages").childByAutoId()
        let messageData: [String: Any] = [
            "text": text,
            "senderID": senderID,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        messagesRef.setValue(messageData) { [weak self] error, _ in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = "Error sending message: \(error.localizedDescription)"
            }
            self.isLoading = false
        }
    }

    private func listenForMessages(chatID: String) {
        let messagesRef = ref.child("chats").child(chatID).child("messages")
        
        messagesRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            var messages: [Message] = []
            
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot,
                      let message = Message(snapshot: snap) else { continue }
                messages.append(message)
            }
            
            self.chat?.messages = messages
        }
        
        messagesRef.observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            if let newMessage = Message(snapshot: snapshot) {
                self.addMessage(newMessage)
            }
        }
    }


    
    private func addMessage(_ message: Message) {
        guard let chatID = chatID else { return }

        if var currentChat = chat {
            currentChat.messages.append(message)
            chat = currentChat
        } else {
            Task {
                let result: Result<User, Error> = await performAsyncOperation {
                    try await self.manager.read(collection: .users, id: message.senderID)
                }
                switch result {
                case .success(let user):
                    let participants: [String: Author] = [message.senderID: Author(user: user)]
                    chat = Chat(id: chatID, participants: participants, messages: [message])
                case .failure:
                    break
                }
            }
        }
    }


    
    private func recreateChat(from snapshot: DataSnapshot) -> Chat? {
        guard let chatData = snapshot.value as? [String: Any],
              let participantsData = chatData["participants"] as? [String: [String: String]]
        else {
            return nil
        }
        
        let participants = participantsData.compactMapValues { dict -> Author? in
            guard let name = dict["name"], let id = dict["id"] else { return nil }
            let profilePicture = dict["profilePicture"]
            return Author(id: id, name: name, profilePicture: profilePicture)
        }
        
        let messagesData = (chatData["messages"] as? [String: [String: Any]])?.compactMap { key, data -> Message? in
            guard let text = data["text"] as? String,
                  let senderID = data["senderID"] as? String,
                  let timestamp = data["timestamp"] as? Double else {
                return nil
            }
            return Message(id: key, text: text, senderID: senderID, timestamp: timestamp)
        } ?? []
        
        return Chat(id: snapshot.key, participants: participants, messages: messagesData)
    }

    
    private func appendChatToUsers(lhs: String, rhs: String, chatID: String) async {
        let result: Result<[User], Error> = await performAsyncOperation {
            try await self.manager.findAll(collection: .users, ids: [lhs, rhs])
        }
        
        if case .success(let users) = result {
            for u in users {
                u.chats.append(chatID)
            }
            
            _ = await performAsyncOperation {
                try await self.manager.update(collection: .users, id: users[0].id, object: users[0])
                try await self.manager.update(collection: .users, id: users[1].id, object: users[1])
            }
            
        }
    }
    
    
    /// Finds chat, retruns and set it 
    /// - Returns: chat or nil
    func findChat() async -> Chat? {
        self.isLoading = true
        defer { self.isLoading = false }
        return await withCheckedContinuation { continuation in
            let chatsRef = ref.child("chats")
            
            chatsRef.observeSingleEvent(of: .value) { snapshot in
                if let existingChatSnapshot = snapshot.children.allObjects.first(where: { snap in
                    guard let snap = snap as? DataSnapshot,
                          let _ = snap.value as? [String: Any] else {
                        return false
                    }
                    return snap.key == self.chatID!
                }) as? DataSnapshot {
                    let chat = self.recreateChat(from: existingChatSnapshot)
                    self.chat = chat
                    continuation.resume(returning: chat)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    func observeChatMessages() {
        self.isLoading = true
        defer {self.isLoading = false}
        
        let messagesRef = ref.child("chats").child(chatID!).child("messages")
        

        var messageIDs: Set<String> = []
     
        messagesRef.observe(.value) { snapshot in
            var messages: [Message] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot, let message = Message(snapshot: snap) {
                    messages.append(message)
                    messageIDs.insert(message.id)
                }
            }
            self.chat?.messages = messages.sorted { $0.timestamp < $1.timestamp }
        }
        
        messagesRef.observe(.childAdded) { snapshot in
            if let newMessage = Message(snapshot: snapshot), !messageIDs.contains(newMessage.id) {
                self.chat?.messages.append(newMessage)
                self.chat?.messages.sort { $0.timestamp < $1.timestamp }
                messageIDs.insert(newMessage.id)
            }
        }
    }


}
