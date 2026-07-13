import SwiftUI

struct ProviderSettingsView: View {
    @Bindable private var settings = AppSettings.shared
    @State private var apiKeyInput = ""
    @State private var showKey = false
    @State private var keySaved = false
    @State private var testResult = ""
    @State private var isTesting = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader("Provider")

            SettingsRow("Type:") {
                Picker("", selection: $settings.providerType) {
                    ForEach(ProviderType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 160)
            }

            if settings.providerType == .custom {
                SettingsRow("Name:") {
                    TextField("My Provider", text: $settings.customProviderName)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 220)
                }
                SettingsRow("API Format:") {
                    Picker("", selection: $settings.apiFormat) {
                        Text("OpenAI-compatible").tag(ProviderType.openAI)
                        Text("Anthropic").tag(ProviderType.anthropic)
                    }
                    .labelsHidden()
                    .frame(maxWidth: 200)
                }
            }

            SettingsRow("Base URL:") {
                TextField(settings.providerType.defaultBaseURL, text: $settings.baseURL)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 320)
            }

            SettingsRow("Model:") {
                TextField(settings.providerType.defaultModel, text: $settings.model)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 220)
            }

            SettingsRow("API Key:") {
                Group {
                    if showKey {
                        TextField("sk-...", text: $apiKeyInput)
                    } else {
                        SecureField("sk-...", text: $apiKeyInput)
                    }
                }
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 220)
                .onAppear {
                    apiKeyInput = "__SET_LOCALLY__"
                }

                Button { showKey.toggle() } label: {
                    Image(systemName: showKey ? "eye.slash" : "eye")
                }
                .buttonStyle(.plain)
                .controlSize(.small)

                Button(keySaved ? "Saved" : "Save") {
                    try? KeychainHelper.save(key: "llm_api_key", value: apiKeyInput)
                    keySaved = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { keySaved = false }
                }
                .disabled(apiKeyInput.isEmpty)
                .controlSize(.small)
            }

            SettingsDivider()

            HStack(spacing: InquiroSpacing.md) {
                Button("Test Connection") {
                    Task { await testConnection() }
                }
                .controlSize(.small)
                .disabled(isTesting)

                if !testResult.isEmpty {
                    Text(testResult)
                        .font(.callout)
                        .foregroundStyle(testResult.hasPrefix("Error") ? InquiroColors.warning : InquiroColors.success)
                }
            }
        }
    }

    private func testConnection() async {
        isTesting = true
        testResult = "Testing..."
        defer { isTesting = false }

        guard let provider = ProviderFactory.createLLM(for: settings) else {
            testResult = "Error: No API key saved"
            return
        }
        do {
            let result = try await provider.testConnection(model: settings.effectiveModel)
            testResult = result
        } catch {
            testResult = "Error: \(error.localizedDescription)"
        }
    }
}
