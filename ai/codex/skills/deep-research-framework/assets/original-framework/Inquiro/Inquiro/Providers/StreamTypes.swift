import Foundation

struct StreamChunk: Sendable {
    enum ChunkType: Sendable {
        case text(String)
        case thinking(String)
        case done
        case error(String)
    }
    let type: ChunkType
    let model: String?

    init(_ type: ChunkType, model: String? = nil) {
        self.type = type
        self.model = model
    }
}

struct ModelInfo: Sendable, Identifiable {
    let id: String
    let displayName: String
    let contextWindow: Int?

    init(id: String, displayName: String? = nil, contextWindow: Int? = nil) {
        self.id = id
        self.displayName = displayName ?? id
        self.contextWindow = contextWindow
    }
}

struct ProviderMessage: Sendable {
    let role: MessageRole
    let content: String
}
