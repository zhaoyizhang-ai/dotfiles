import Foundation

@MainActor
enum ProviderFactory {
    static func createLLM(for settings: AppSettings) -> (any LLMProvider)? {
        guard let apiKey = KeychainHelper.load(key: "llm_api_key"), !apiKey.isEmpty else {
            return nil
        }

        let baseURL = settings.effectiveBaseURL
        let providerType = settings.providerType

        switch providerType {
        case .anthropic:
            return AnthropicProvider(baseURL: baseURL, apiKey: apiKey)
        case .openAI:
            return OpenAICompatibleProvider(
                id: "openai",
                displayName: "OpenAI",
                baseURL: baseURL,
                apiKey: "__SET_LOCALLY__"
            )
        case .gemini:
            // TODO: Phase 4 — GeminiProvider
            // For now, fall through to OpenAI-compatible (many Gemini proxies use this)
            return OpenAICompatibleProvider(
                id: "gemini",
                displayName: "Gemini",
                baseURL: baseURL,
                apiKey: "__SET_LOCALLY__"
            )
        case .custom:
            let format = settings.apiFormat
            switch format {
            case .anthropic:
                return AnthropicProvider(baseURL: baseURL, apiKey: apiKey)
            default:
                return OpenAICompatibleProvider(
                    id: "custom",
                    displayName: settings.customProviderName.isEmpty ? "Custom" : settings.customProviderName,
                    baseURL: baseURL,
                    apiKey: "__SET_LOCALLY__"
                )
            }
        }
    }
}
