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
    
    // Function to send a message
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
            } else {
                print("Message sent!")
            }
        }
    }
    
    // Function to listen for new messages in the chat
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
    
    // Add message to the chat
    private func addMessage(_ message: Message) {
        if var currentChat = chat {
            currentChat.messages.append(message)
            chat = currentChat  // Update the published chat object
        } else {
            chat = Chat(id: chatID, participants: [:], messages: [message])
        }
    }
    
    // Function to get or create a chat for two users
    func getOrCreateChat(user1: String, user2: String, completion: @escaping (String) -> Void) {
        let chatsRef = ref.child("chats")
        
        // Searching for an existing chat by participants
        chatsRef.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let participants = childSnapshot.childSnapshot(forPath: "participants").value as? [String: Bool],
                   participants[user1] == true, participants[user2] == true {
                    // Chat already exists
                    completion(childSnapshot.key)
                    return
                }
            }
            
            // Creating a new chat if not found
            let newChatRef = chatsRef.childByAutoId()
            newChatRef.setValue([
                "participants": [user1: true, user2: true],
                "messages": [:] // No messages at the beginning
            ])
            
            completion(newChatRef.key)
        }
    }
}