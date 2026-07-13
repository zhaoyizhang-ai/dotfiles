import Foundation
import SwiftData

@Model
final class Project {
    var name: String
    var projectDescription: String
    var created: Date
    @Relationship(deleteRule: .cascade, inverse: \Session.project)
    var sessions: [Session]

    init(name: String, description: String = "") {
        self.name = name
        self.projectDescription = description
        self.created = Date()
        self.sessions = []
    }
}
