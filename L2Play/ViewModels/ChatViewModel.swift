import Foundation
import FirebaseDatabase
import Combine

class ChatViewModel: ObservableObject {
    private var ref: DatabaseReference!
    private var chatID: UUID?
    
    @Published var isLoading: Bool = false
    @Published var chat: Chat? = nil
    @Published var errorMessage: String?

    init(chatID: UUID?) {
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
        isLoading = true
        let chatsRef = ref.child("chats")
        
        chatsRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            self.isLoading = false
            
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
                    completion(newChat)
                }
            }
        }
    }

    
    private func createChat(participants: [String: Author], completion: @escaping (Chat?) -> Void) {
        let chatsRef = ref.child("chats").childByAutoId()
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
        
        chatsRef.setValue(chatData) { [weak self] error, _ in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = "Failed to create chat: \(error.localizedDescription)"
                completion(nil)
            } else {
                let newChatID = UUID(uuidString: chatsRef.key ?? UUID().uuidString) ?? UUID()
                let newChat = Chat(id: newChatID, participants: participants, messages: [])
                self.chatID = newChatID
                completion(newChat)
                self.listenForMessages(chatID: newChatID)
            }
        }
    }

    func sendMessage(text: String, senderID: String) {
        guard let chatID = chatID else {
            errorMessage = "No chat available to send message."
            return
        }
        
        isLoading = true
        let messagesRef = ref.child("chats").child(chatID.uuidString).child("messages").childByAutoId()
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

    private func listenForMessages(chatID: UUID) {
        let messagesRef = ref.child("chats").child(chatID.uuidString).child("messages")
        
        messagesRef.observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            if let newMessage = Message(snapshot: snapshot) {
                self.addMessage(newMessage)
            }
        }
    }

    private func addMessage(_ message: Message) {
        if var currentChat = chat {
            currentChat.messages.append(message)
            chat = currentChat
        } else {
            chat = Chat(id: chatID ?? UUID(), participants: [:], messages: [message])
        }
    }

    private func recreateChat(from snapshot: DataSnapshot) -> Chat? {
        guard let chatData = snapshot.value as? [String: Any],
              let participantsData = chatData["participants"] as? [String: [String: String]],
              let messagesData = chatData["messages"] as? [[String: Any]] else {
            return nil
        }
        
        let participants = participantsData.compactMapValues { dict -> Author? in
            guard let name = dict["name"], let id = dict["id"] else { return nil }
            let profilePicture = dict["profilePicture"]
            return Author(id: id, name: name, profilePicture: profilePicture)
        }
        
        let messages = messagesData.compactMap { data -> Message? in
            guard let text = data["text"] as? String,
                  let senderIDString = data["senderID"] as? String,
                  let senderID = UUID(uuidString: senderIDString),
                  let timestamp = data["timestamp"] as? Double else { return nil }
            return Message(text: text, senderID: senderID, timestamp: timestamp)
        }
        
        return Chat(id: UUID(uuidString: snapshot.key) ?? UUID(), participants: participants, messages: messages)
    }

}
