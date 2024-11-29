import Foundation

struct Chat {
    var id: String
    var participants: [String: Bool]
    var messages: [Message]
}