import UIKit
import FirebaseDatabase

class ChatViewController: UIViewController {
    var ref: DatabaseReference!
    var messages: [String] = []
    var chatID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Listen for new messages in the chat
        listenForMessages(chatID: chatID)
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
        messageRef.setValue(messageData) { error, _ in
            if let error = error {
                print("Błąd przy wysyłaniu wiadomości: \(error.localizedDescription)")
            } else {
                print("Wiadomość wysłana!")
            }
        }
    }

    // Function to listen for new messages in the chat
    func listenForMessages(chatID: String) {
        let messagesRef = ref.child("chats").child(chatID).child("messages")
        
        messagesRef.observe(.childAdded) { snapshot in
            if let messageData = snapshot.value as? [String: Any],
               let text = messageData["text"] as? String,
               let senderId = messageData["senderId"] as? String,
               let timestamp = messageData["timestamp"] as? TimeInterval {
                print("Nowa wiadomość od \(senderId): \(text)")
                //TODO UPDATE UI HERE
            }
        }
    }
func getOrCreateChat(user1: String, user2: String, completion: @escaping (String) -> Void) {
    let chatsRef = Database.database().reference().child("chats")
    
    // Searching for existing chat by participants
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
        
        // Creating new chat if not found
        let newChatRef = chatsRef.childByAutoId()
        newChatRef.setValue([
            "participants": [user1: true, user2: true],
            "messages": [:] // Empty messages initially
        ])
        
        completion(newChatRef.key)
    }
}    

}
