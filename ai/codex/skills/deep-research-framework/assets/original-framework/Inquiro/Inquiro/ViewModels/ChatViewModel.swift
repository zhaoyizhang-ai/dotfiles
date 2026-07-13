import SwiftUI
import SwiftData

@Observable
@MainActor
final class ChatViewModel {
    var session: Session?
    var streamingContent: String = ""
    var isStreaming: Bool = false
    var errorMessage: String?

    private var streamTask: Task<Void, Never>?
    private var modelContext: ModelContext?

    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }

    func createSession(in project: Project) {
        let session = Session(title: "New Chat", mode: .chat, project: project)
        modelContext?.insert(session)
        try? modelContext?.save()
        self.session = session
    }

    func send(content: String, model: String, settings: AppSettings) {
        guard let session, let modelContext else { return }
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        // Add user message
        let userMessage = Message(role: .user, content: content)
        userMessage.session = session
        session.messages.append(userMessage)
        session.updated = Date()

        // Update title from first message
        if session.messages.count == 1 {
            session.title = String(content.prefix(50))
        }

        try? modelContext.save()

        // Build provider messages
        let providerMessages = session.sortedMessages.map { msg in
            ProviderMessage(role: msg.messageRole, content: msg.content)
        }

        // Create provider
        guard let provider = ProviderFactory.createLLM(for: settings) else {
            errorMessage = "No API provider configured. Check Settings."
            return
        }

        let pipeline = ChatPipeline(provider: provider)
        let input = ChatPipeline.Input(
            messages: providerMessages,
            systemPrompt: session.systemPrompt,
            model: model
        )

        isStreaming = true
        streamingContent = ""
        errorMessage = nil

        streamTask = Task {
            do {
                let events = try await pipeline.execute(input)
                for await event in events {
                    switch event {
                    case .streamingToken(let token):
                        streamingContent += token
                    case .streamingDone:
                        finalizeMessage(model: model)
                    case .error(let msg):
                        errorMessage = msg
                        isStreaming = false
                    default:
                        break
                    }
                }
            } catch {
                errorMessage = error.localizedDescription
                isStreaming = false
            }
        }
    }

    func cancelStream() {
        streamTask?.cancel()
        streamTask = nil
        if !streamingContent.isEmpty {
            finalizeMessage(model: nil)
        }
        isStreaming = false
    }

    private func finalizeMessage(model: String?) {
        guard let session, let modelContext, !streamingContent.isEmpty else { return }
        let assistantMessage = Message(role: .assistant, content: streamingContent, model: model)
        assistantMessage.session = session
        session.messages.append(assistantMessage)
        session.updated = Date()
        try? modelContext.save()
        streamingContent = ""
        isStreaming = false
    }
}
