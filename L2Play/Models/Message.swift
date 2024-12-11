import Foundation
import FirebaseDatabase
import Combine

extension Message {
    init?(snapshot: DataSnapshot) {
        guard let messageData = snapshot.value as? [String: Any],
              let text = messageData["text"] as? String,
              let senderID = messageData["senderID"] as? String,
              let timestamp = messageData["timestamp"] as? Double else {
            return nil
        }
        
        self.id = snapshot.key 
        self.text = text
        self.senderID = senderID
        self.timestamp = timestamp
    }
}



struct Message {
    private(set) var uid: UUID = .init()
    var id: String
    var text: String
    var senderID: String
    var timestamp: Double
    
    func isMe(_ currID: String) -> Bool {
        return senderID == currID
    }
}
