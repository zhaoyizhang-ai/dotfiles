import Foundation

enum ProviderType: String, Codable, CaseIterable, Sendable {
    case anthropic = "Anthropic"
    case openAI = "OpenAI"
    case gemini = "Gemini"
    case custom = "Custom"

    var defaultBaseURL: String {
        switch self {
        case .anthropic: AppConstants.defaultAnthropicBaseURL
        case .openAI: AppConstants.defaultOpenAIBaseURL
        case .gemini: AppConstants.defaultGeminiBaseURL
        case .custom: ""
        }
    }

    var defaultModel: String {
        switch self {
        case .anthropic: AppConstants.defaultAnthropicModel
        case .openAI: AppConstants.defaultOpenAIModel
        case .gemini: AppConstants.defaultGeminiModel
        case .custom: ""
        }
    }

    var apiFormatLabel: String {
        switch self {
        case .anthropic: "Anthropic"
        case .openAI, .custom: "OpenAI-compatible"
        case .gemini: "Gemini"
        }
    }
}

enum SessionMode: String, Codable, CaseIterable, Sendable {
    case chat = "Chat"
    case research = "Research"
    case brainstorm = "Brainstorm"
}

enum MessageRole: String, Codable, Sendable {
    case user
    case assistant
    case system
}
