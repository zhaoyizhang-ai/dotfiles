import Foundation

protocol LLMProvider: Sendable {
    var id: String { get }
    var displayName: String { get }

    func complete(
        _ messages: [ProviderMessage],
        model: String,
        systemPrompt: String?,
        stream: Bool
    ) async throws -> AsyncStream<StreamChunk>

    func testConnection(model: String) async throws -> String
}

extension LLMProvider {
    func testConnection(model: String) async throws -> String {
        let messages = [ProviderMessage(role: .user, content: "Respond with exactly: Connection successful.")]
        var result = ""
        for await chunk in try await complete(messages, model: model, systemPrompt: nil, stream: false) {
            if case .text(let text) = chunk.type {
                result += text
            }
        }
        return result
    }
}

enum LLMError: Error, LocalizedError {
    case invalidURL(String)
    case apiError(String)
    case noResponse
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let url): "Invalid URL: \(url)"
        case .apiError(let msg): msg
        case .noResponse: "No response from API"
        case .decodingError(let msg): "Decoding error: \(msg)"
        }
    }
}
