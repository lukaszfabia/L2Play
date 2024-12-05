import Foundation
import FirebaseDatabase
import Combine

extension Message {
    init?(snapshot: DataSnapshot) {
        guard let messageData = snapshot.value as? [String: Any],
              let text = messageData["text"] as? String,
              let senderIDString = messageData["senderID"] as? String,
              let senderID = UUID(uuidString: senderIDString),
              let timestamp = messageData["timestamp"] as? Double else {
            return nil
        }
        
        self.id = UUID(uuidString: snapshot.key) ?? UUID()
        self.text = text
        self.senderID = senderID
        self.timestamp = timestamp
    }
}



struct Message: Identifiable {
    private(set) var id: UUID = .init()
    var text: String
    var senderID: UUID
    var timestamp: Double // since 1970
    
    init(text: String, senderID: UUID) {
        self.id = .init()
        self.text = text
        self.senderID = senderID
        self.timestamp = Date().timeIntervalSince1970
    }
    
    init(text: String, senderID: UUID, timestamp: Double) {
        self.id = .init()
        self.text = text
        self.senderID = senderID
        self.timestamp = timestamp
    }
    
    func isMe(_ senderID: UUID) -> Bool {
        self.senderID == senderID
    }
}
