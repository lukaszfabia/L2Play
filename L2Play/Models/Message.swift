import Foundation

struct Message: Identifiable {
    var id: String
    var text: String
    var senderId: String
    var timestamp: Double
}