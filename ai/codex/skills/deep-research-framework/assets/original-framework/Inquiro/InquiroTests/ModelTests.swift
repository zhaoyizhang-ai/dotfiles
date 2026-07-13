import Testing
@testable import Inquiro

@Test func projectCreation() {
    let project = Project(name: "Test Project", description: "A test")
    #expect(project.name == "Test Project")
    #expect(project.sessions.isEmpty)
}

@Test func sessionCreation() {
    let session = Session(title: "Test Chat", mode: .chat)
    #expect(session.sessionMode == .chat)
    #expect(session.messages.isEmpty)
}

@Test func messageCreation() {
    let msg = Message(role: .user, content: "Hello", model: "claude-opus-4-6")
    #expect(msg.messageRole == .user)
    #expect(msg.content == "Hello")
    #expect(msg.modelUsed == "claude-opus-4-6")
}

@Test func providerTypeDefaults() {
    #expect(ProviderType.anthropic.defaultBaseURL == "https://api.anthropic.com")
    #expect(ProviderType.openAI.defaultModel == "gpt-4o")
    #expect(ProviderType.custom.defaultBaseURL == "")
}
