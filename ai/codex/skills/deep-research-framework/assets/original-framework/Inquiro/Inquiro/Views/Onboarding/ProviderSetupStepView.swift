import SwiftUI

struct ProviderSetupStepView: View {
    @Bindable private var settings = AppSettings.shared
    @State private var apiKeyInput = ""
    @State private var keySaved = false
    @State private var testResult = ""
    @State private var isTesting = false
    @State private var showAdvanced = false

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.filled.head.profile")
                .font(.system(size: 48))
                .foregroundStyle(InquiroColors.chat)

            Text("Set Up Your AI Provider")
                .font(.title2.bold())

            // Provider presets
            HStack(spacing: 12) {
                providerButton(.anthropic, icon: "a.circle.fill")
                providerButton(.openAI, icon: "circle.hexagongrid.fill")
                providerButton(.gemini, icon: "diamond.fill")
                providerButton(.custom, icon: "wrench.and.screwdriver.fill")
            }

            // Fields
            VStack(spacing: 8) {
                if settings.providerType == .custom {
                    TextField("Provider Name", text: $settings.customProviderName)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 380)

                    TextField("Base URL", text: $settings.baseURL)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 380)

                    Picker("API Format", selection: $settings.apiFormat) {
                        Text("OpenAI-compatible").tag(ProviderType.openAI)
                        Text("Anthropic").tag(ProviderType.anthropic)
                    }
                    .frame(maxWidth: 380)
                }

                SecureField("API Key", text: $apiKeyInput)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 380)

                if settings.providerType != .custom {
                    DisclosureGroup("Advanced", isExpanded: $showAdvanced) {
                        TextField("Base URL (default: \(settings.providerType.defaultBaseURL))", text: $settings.baseURL)
                            .textFieldStyle(.roundedBorder)
                        TextField("Model (default: \(settings.providerType.defaultModel))", text: $settings.model)
                            .textFieldStyle(.roundedBorder)
                    }
                    .frame(maxWidth: 380)
                }
            }

            // Test + Save
            HStack(spacing: 12) {
                Button(keySaved ? "Saved" : "Save & Test") {
                    Task { await saveAndTest() }
                }
                .buttonStyle(.borderedProminent)
                .disabled(apiKeyInput.isEmpty || isTesting)
            }

            if !testResult.isEmpty {
                Label(testResult, systemImage: testResult.hasPrefix("Error") ? "xmark.circle" : "checkmark.circle")
                    .font(.callout)
                    .foregroundStyle(testResult.hasPrefix("Error") ? InquiroColors.warning : InquiroColors.success)
            }
        }
        .padding()
    }

    private func providerButton(_ type: ProviderType, icon: String) -> some View {
        Button {
            settings.providerType = type
            showAdvanced = false
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(type.rawValue)
                    .font(.caption)
            }
            .frame(width: 72, height: 56)
            .background(settings.providerType == type ? Color.accentColor.opacity(0.15) : InquiroColors.surfaceAlt)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(settings.providerType == type ? Color.accentColor : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private func saveAndTest() async {
        try? KeychainHelper.save(key: "llm_api_key", value: apiKeyInput)
        keySaved = true
        isTesting = true
        testResult = "Testing..."

        guard let provider = ProviderFactory.createLLM(for: settings) else {
            testResult = "Error: Could not create provider"
            isTesting = false
            return
        }
        do {
            let result = try await provider.testConnection(model: settings.effectiveModel)
            testResult = result
        } catch {
            testResult = "Error: \(error.localizedDescription)"
        }
        isTesting = false
    }
}
