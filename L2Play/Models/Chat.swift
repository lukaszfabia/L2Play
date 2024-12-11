import Foundation

struct Chat {
    private(set) var id: String
    var participants: [String: Author] // id - short inffo
    var messages: [Message]
    
    init(id: String, participants: [String : Author], messages: [Message]) {
        self.id = id
        self.participants = participants
        self.messages = messages
    }
    
    var lastMessageTimestamp: Double {
            messages.last?.timestamp ?? 0
    }
}
