import Foundation
import SwiftData

@Model
final class Message {
    var role: String  // MessageRole raw value
    var content: String
    var timestamp: Date
    var session: Session?
    var modelUsed: String?

    init(role: MessageRole, content: String, model: String? = nil) {
        self.role = role.rawValue
        self.content = content
        self.timestamp = Date()
        self.modelUsed = model
    }

    var messageRole: MessageRole {
        MessageRole(rawValue: role) ?? .user
    }
}
