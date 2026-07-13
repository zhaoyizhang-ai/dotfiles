import Foundation

struct MarkdownExporter: ExportProtocol {
    let fileExtension = "md"
    let mimeType = "text/markdown"

    func export(session: Session) throws -> Data {
        var lines: [String] = []

        lines.append("# \(session.title)")
        lines.append("")
        lines.append("**Mode:** \(session.sessionMode.rawValue)")
        lines.append("**Created:** \(formatted(session.created))")
        lines.append("**Updated:** \(formatted(session.updated))")
        lines.append("")
        lines.append("---")
        lines.append("")

        for message in session.sortedMessages {
            let prefix = message.messageRole == .user ? "**User:**" : "**Assistant:**"
            lines.append(prefix)
            lines.append("")
            lines.append(message.content)
            lines.append("")
            if let model = message.modelUsed {
                lines.append("*Model: \(model)*")
                lines.append("")
            }
            lines.append("---")
            lines.append("")
        }

        let content = lines.joined(separator: "\n")
        guard let data = content.data(using: .utf8) else {
            throw ExportError.encodingFailed
        }
        return data
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

enum ExportError: Error, LocalizedError {
    case encodingFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodingFailed: "Failed to encode content"
        case .writeFailed(let path): "Failed to write to \(path)"
        }
    }
}
