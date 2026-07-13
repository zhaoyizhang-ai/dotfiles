import SwiftUI

@Observable
@MainActor
final class AppSettings {
    static let shared = AppSettings()

    private let defaults = UserDefaults.standard

    // Provider
    var providerType: ProviderType {
        didSet { defaults.set(providerType.rawValue, forKey: "providerType") }
    }
    var baseURL: String {
        didSet { defaults.set(baseURL, forKey: "baseURL") }
    }
    var model: String {
        didSet { defaults.set(model, forKey: "model") }
    }
    var customProviderName: String {
        didSet { defaults.set(customProviderName, forKey: "customProviderName") }
    }
    var apiFormat: ProviderType {
        didSet { defaults.set(apiFormat.rawValue, forKey: "apiFormat") }
    }

    var effectiveBaseURL: String {
        baseURL.isEmpty ? providerType.defaultBaseURL : baseURL
    }
    var effectiveModel: String {
        model.isEmpty ? providerType.defaultModel : model
    }

    // General
    var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }
    var appearance: String {
        didSet { defaults.set(appearance, forKey: "appearance") }
    }

    // Search
    var searchProvider: String {
        didSet { defaults.set(searchProvider, forKey: "searchProvider") }
    }
    var searchBaseURL: String {
        didSet { defaults.set(searchBaseURL, forKey: "searchBaseURL") }
    }

    private init() {
        let d = UserDefaults.standard
        providerType = ProviderType(rawValue: d.string(forKey: "providerType") ?? "") ?? .anthropic
        baseURL = d.string(forKey: "baseURL") ?? ""
        model = d.string(forKey: "model") ?? ""
        customProviderName = d.string(forKey: "customProviderName") ?? ""
        apiFormat = ProviderType(rawValue: d.string(forKey: "apiFormat") ?? "") ?? .openAI
        hasCompletedOnboarding = d.bool(forKey: "hasCompletedOnboarding")
        appearance = d.string(forKey: "appearance") ?? "system"
        searchProvider = d.string(forKey: "searchProvider") ?? "none"
        searchBaseURL = d.string(forKey: "searchBaseURL") ?? ""
    }
}
