import Foundation
import FirebaseDatabase
import Combine

class ChatViewModel: ObservableObject {
    private var ref: DatabaseReference!
    @Published var chat: Chat?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    private var chatID: String
    private var cancellables: Set<AnyCancellable> = []
    
    init(chatID: String) {
        self.chatID = chatID
        self.ref = Database.database().reference()
        listenForMessages()
    }
    
    func sendMessage(text: String, senderId: String) {
        let timestamp = Date().timeIntervalSince1970
        let messageData: [String: Any] = [
            "text": text,
            "senderId": senderId,
            "timestamp": timestamp
        ]
        
        let messagesRef = ref.child("chats").child(chatID).child("messages")
        let messageRef = messagesRef.childByAutoId()
        messageRef.setValue(messageData) { [weak self] error, _ in
            if let error = error {
                self?.errorMessage = "Error during sending a message: \(error.localizedDescription)"
            }
        }
    }
    
    private func listenForMessages() {
        isLoading = true
        let messagesRef = ref.child("chats").child(chatID).child("messages")
        
        messagesRef.observe(.childAdded) { [weak self] snapshot in
            if let messageData = snapshot.value as? [String: Any],
               let text = messageData["text"] as? String,
               let senderId = messageData["senderId"] as? String,
               let timestamp = messageData["timestamp"] as? Double {
                
                let newMessage = Message(
                    id: snapshot.key,
                    text: text,
                    senderId: senderId,
                    timestamp: timestamp
                )
                
                self?.addMessage(newMessage)
            }
            self?.isLoading = false
        }
    }
    
    private func addMessage(_ message: Message) {
        if var currentChat = chat {
            currentChat.messages.append(message)
            chat = currentChat
        } else {
            chat = Chat(id: chatID, participants: [:], messages: [message])
        }
    }
}
