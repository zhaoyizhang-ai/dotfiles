import SwiftUI

struct GeneralSettingsView: View {
    @Bindable private var settings = AppSettings.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader("Appearance")

            SettingsRow("Theme:") {
                Picker("", selection: $settings.appearance) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .labelsHidden()
                .frame(maxWidth: 160)
            }

            SettingsDivider()

            SectionHeader("Keyboard Shortcuts")
            SettingsDescription("Default shortcuts — customizable in a future update.")

            VStack(alignment: .leading, spacing: 4) {
                shortcutRow("\u{2318}N", "New session")
                shortcutRow("\u{2318}1/2/3", "Chat / Research / Brainstorm")
                shortcutRow("\u{2318}Enter", "Send message")
                shortcutRow("\u{2318}K", "Quick model switcher")
                shortcutRow("\u{2318}/", "Toggle sidebar")
                shortcutRow("Esc", "Cancel / close")
            }
        }
    }

    private func shortcutRow(_ shortcut: String, _ action: String) -> some View {
        HStack {
            Text(shortcut)
                .font(InquiroTypography.code)
                .foregroundStyle(InquiroColors.textSecondary)
                .frame(width: 100, alignment: .leading)
            Text(action)
                .font(InquiroTypography.body)
                .foregroundStyle(InquiroColors.textPrimary)
        }
        .padding(.vertical, 2)
    }
}
