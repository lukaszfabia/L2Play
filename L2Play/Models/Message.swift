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
        
        self.text = text
        self.senderID = senderID
        self.timestamp = timestamp
    }
}



struct Message: Identifiable, Equatable {
    private(set) var id: UUID = .init()
    var text: String
    var senderID: String
    var timestamp: Double
    
    init(text: String, senderID: String) {
        self.text = text
        self.senderID = senderID
        self.timestamp = Date().timeIntervalSince1970
    }
    
    init(text: String, senderID: String, timestamp: Double) {
        self.text = text
        self.senderID = senderID
        self.timestamp = timestamp
    }

    
    init?(from dictionary: [String: Any]) {
        guard let senderID = dictionary["senderID"] as? String,
              let text = dictionary["text"] as? String,
              let timestamp = dictionary["timestamp"] as? Double else {
            print("cent dedncfvsjuodfns")
            return nil
        }
        
        self.init(text: text, senderID: senderID, timestamp: timestamp)
    }
    
    func isMe(_ currID: String) -> Bool {
        return senderID == currID
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "senderID": senderID,
            "text": text,
            "timestamp": timestamp
        ]
    }
}
