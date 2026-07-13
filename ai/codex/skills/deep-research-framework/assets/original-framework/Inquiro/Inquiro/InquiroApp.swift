import SwiftUI
import SwiftData

@main
struct InquiroApp: App {
    @Environment(\.openWindow) private var openWindow
    @State private var didCheckOnboarding = false
    @Bindable private var settings = AppSettings.shared

    let container: ModelContainer

    init() {
        do {
            let schema = Schema([
                Project.self,
                Session.self,
                Message.self,
            ])
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .onAppear {
                    if !didCheckOnboarding {
                        didCheckOnboarding = true
                        if !settings.hasCompletedOnboarding {
                            openWindow(id: "onboarding")
                        }
                    }
                }
        }
        .defaultSize(width: 1000, height: 700)

        Window("Settings", id: "settings") {
            SettingsView()
        }
        .windowResizability(.contentSize)
        .keyboardShortcut(",", modifiers: .command)

        Window("Onboarding", id: "onboarding") {
            OnboardingView()
        }
        .windowResizability(.contentSize)
    }
}
