import Foundation
import SwiftData

@Model
final class Session {
    var title: String
    var mode: String  // SessionMode raw value
    var created: Date
    var updated: Date
    var project: Project?
    @Relationship(deleteRule: .cascade, inverse: \Message.session)
    var messages: [Message]
    var systemPrompt: String?
    var modelID: String?

    init(title: String, mode: SessionMode, project: Project? = nil) {
        self.title = title
        self.mode = mode.rawValue
        self.created = Date()
        self.updated = Date()
        self.project = project
        self.messages = []
    }

    var sessionMode: SessionMode {
        get { SessionMode(rawValue: mode) ?? .chat }
        set { mode = newValue.rawValue }
    }

    var sortedMessages: [Message] {
        messages.sorted { $0.timestamp < $1.timestamp }
    }
}
