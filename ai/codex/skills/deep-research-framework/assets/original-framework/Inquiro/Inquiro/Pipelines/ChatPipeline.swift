import Foundation

final class ChatPipeline: PipelineProtocol, @unchecked Sendable {
    struct Input: Sendable {
        let messages: [ProviderMessage]
        let systemPrompt: String?
        let model: String
    }

    private let provider: any LLMProvider

    init(provider: any LLMProvider) {
        self.provider = provider
    }

    func execute(_ input: Input) async throws -> AsyncStream<PipelineEvent> {
        let stream = try await provider.complete(
            input.messages,
            model: input.model,
            systemPrompt: input.systemPrompt,
            stream: true
        )

        return AsyncStream { continuation in
            Task {
                for await chunk in stream {
                    switch chunk.type {
                    case .text(let text):
                        continuation.yield(.streamingToken(text))
                    case .done:
                        continuation.yield(.streamingDone)
                    case .error(let msg):
                        continuation.yield(.error(msg))
                    case .thinking:
                        break // ignore for now
                    }
                }
                continuation.finish()
            }
        }
    }
}
