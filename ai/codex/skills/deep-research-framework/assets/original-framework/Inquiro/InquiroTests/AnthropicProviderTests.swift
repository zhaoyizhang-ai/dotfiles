import Testing
@testable import Inquiro

@Test func anthropicProviderInit() {
    let provider = AnthropicProvider(apiKey: "__SET_LOCALLY__")
    #expect(provider.id == "anthropic")
    #expect(provider.displayName == "Anthropic")
}

@Test func anthropicProviderCustomBaseURL() {
    let provider = AnthropicProvider(
        baseURL: "https://my-proxy.com/anthropic",
        apiKey: "__SET_LOCALLY__"
    )
    #expect(provider.id == "anthropic")
}
