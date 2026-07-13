import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedSession: Session?
    @State private var chatVM = ChatViewModel()
    @Bindable private var settings = AppSettings.shared

    var body: some View {
        NavigationSplitView {
            SidebarView(selectedSession: $selectedSession)
        } detail: {
            if let session = selectedSession {
                ChatView(session: session, viewModel: chatVM)
            } else {
                emptyState
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(InquiroColors.background)
        .onAppear {
            chatVM.setContext(modelContext)
        }
    }

    private var emptyState: some View {
        VStack(spacing: InquiroSpacing.lg) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 48))
                .foregroundStyle(InquiroColors.textTertiary)
            Text("Start a new session")
                .font(InquiroTypography.sectionHeading)
                .foregroundStyle(InquiroColors.textSecondary)
            Text("Press \u{2318}N to create a new session")
                .font(InquiroTypography.body)
                .foregroundStyle(InquiroColors.textTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(InquiroColors.background)
    }
}
