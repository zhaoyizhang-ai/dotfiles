import Testing
@testable import Inquiro

@Test func openAIProviderInit() {
    let provider = OpenAICompatibleProvider(
        baseURL: "https://api.openai.com/v1",
        apiKey: "__SET_LOCALLY__"
    )
    #expect(provider.id == "openai")
    #expect(provider.displayName == "OpenAI")
}

@Test func openAIProviderTrailingSlash() {
    // Should handle trailing slash in base URL
    let provider = OpenAICompatibleProvider(
        baseURL: "https://api.openai.com/v1/",
        apiKey: "__SET_LOCALLY__"
    )
    #expect(provider.id == "openai")
}
