import Foundation

class Chat {
    private(set) var id: String
    var participants: [String: Author] // id - short inffo
    var messages: [Message]
    
    init(id: String, participants: [String : Author], messages: [Message]) {
        self.id = id
        self.participants = participants
        self.messages = messages
    }
    
    convenience init?(from dictionary: [String: Any], chatID: String) {
        guard let participantsData = dictionary["participants"] as? [String: [String: Any]] else {
            
            return nil
        }

        let messagesData = dictionary["messages"] as? [String : [String: Any]]
        
        var messages: [Message] = []
        if let messagesData = messagesData, !messagesData.isEmpty {
            messages = messagesData.compactMap { Message(from: $0.value) }
        }

        let participants = participantsData.compactMapValues { Author(from: $0) }
        
        guard !participants.isEmpty else {
            return nil
        }
        
        self.init(id: chatID, participants: participants, messages: messages)
    }

    
    var lastMessageTimestamp: Double {
            messages.last?.timestamp ?? 0
    }
    
    func addMessage(message: Message) {
        messages.append(message)
    }
    
    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "participants": participants.mapValues { $0.toDictionary() },
            "messages": messages.map { $0.toDictionary() }
        ]
        return dictionary
    }
}


struct ChatData: Identifiable {
    private(set) var id: UUID = .init()
    let chatID: String
    let participants: [String: Author]
    let lastMessage: Message?
    
    init(chatID: String, participants: [String: Author], lastMessage: Message?) {
        self.chatID = chatID
        self.participants = participants
        self.lastMessage = lastMessage
    }
    
    init?(from dictionary: [String: Any], chatID: String) {
        self.chatID = chatID
        
        guard let participantsData = dictionary["participants"] as? [String: [String: Any]] else {
            return nil
        }
        
        var participants: [String: Author] = [:]
        for (id, participantData) in participantsData {
            if let author = Author(from: participantData) {
                participants[id] = author
            }
        }

        self.participants = participants

        let messagesData = dictionary["messages"] as? [String : [String: Any]]
        
        if let messagesData = messagesData, !messagesData.isEmpty {
            self.lastMessage = messagesData.compactMap { Message(from: $0.value) }.sorted {
                $0.timestamp < $1.timestamp
            }.last
        } else {
            self.lastMessage = nil
        }
    }

    
    func getReceiver(authID: String) -> Author? {
        for participant in participants {
            if participant.key != authID {
                return participant.value
            }
        }
        
        return nil
    }

}
