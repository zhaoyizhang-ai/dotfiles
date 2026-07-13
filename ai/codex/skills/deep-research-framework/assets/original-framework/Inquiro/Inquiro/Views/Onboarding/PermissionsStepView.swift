import SwiftUI

struct PermissionsStepView: View {
    @State private var accessibilityGranted = PermissionsService.checkAccessibilityPermission()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 48))
                .foregroundStyle(InquiroColors.research)

            Text("Permissions")
                .font(.title2.bold())

            Text("Inquiro needs a few permissions to work properly.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                permissionRow(
                    icon: "keyboard.fill",
                    title: "Accessibility",
                    description: "Global keyboard shortcuts",
                    isGranted: accessibilityGranted,
                    action: { PermissionsService.requestAccessibilityPermission() }
                )

                permissionRow(
                    icon: "globe",
                    title: "Network",
                    description: "Connect to AI providers",
                    isGranted: true,
                    action: {}
                )
            }
            .padding(.horizontal, 40)

            Text("You can change permissions later in System Settings.")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .onReceive(timer) { _ in
            accessibilityGranted = PermissionsService.checkAccessibilityPermission()
        }
    }

    private func permissionRow(icon: String, title: String, description: String, isGranted: Bool, action: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(InquiroColors.textSecondary)
            VStack(alignment: .leading) {
                Text(title).font(.body.bold())
                Text(description).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            if isGranted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(InquiroColors.success)
            } else {
                Button("Grant") { action() }
                    .controlSize(.small)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(InquiroSpacing.md)
        .background(InquiroColors.surfaceAlt)
        .clipShape(RoundedRectangle(cornerRadius: InquiroSpacing.cardCornerRadius))
    }
}
