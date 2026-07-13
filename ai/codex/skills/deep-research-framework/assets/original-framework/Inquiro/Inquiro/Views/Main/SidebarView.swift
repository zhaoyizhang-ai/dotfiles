import SwiftUI
import SwiftData

struct SidebarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Project.created, order: .reverse) private var projects: [Project]
    @Binding var selectedSession: Session?

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("INQUIRO")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(InquiroColors.textTertiary)
                Spacer()
            }
            .padding(.horizontal, InquiroSpacing.lg)
            .padding(.top, InquiroSpacing.md)
            .padding(.bottom, InquiroSpacing.sm)

            // Project list
            List(selection: $selectedSession) {
                ForEach(projects) { project in
                    Section {
                        ForEach(project.sessions.sorted(by: { $0.updated > $1.updated })) { session in
                            sessionRow(session)
                                .tag(session)
                        }
                    } header: {
                        Text(project.name)
                            .font(InquiroTypography.sidebar)
                            .foregroundStyle(InquiroColors.textSecondary)
                    }
                }
            }
            .listStyle(.sidebar)

            Divider()

            // Bottom bar
            HStack {
                Button {
                    createNewSession()
                } label: {
                    Label("New Session", systemImage: "plus")
                        .font(InquiroTypography.sidebar)
                }
                .buttonStyle(.plain)
                .foregroundStyle(InquiroColors.textSecondary)

                Spacer()
            }
            .padding(InquiroSpacing.md)
        }
        .frame(minWidth: InquiroSpacing.sidebarWidth)
        .background(InquiroColors.surface)
    }

    private func sessionRow(_ session: Session) -> some View {
        HStack(spacing: InquiroSpacing.sm) {
            Circle()
                .fill(accentColor(for: session.sessionMode))
                .frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 2) {
                Text(session.title)
                    .font(InquiroTypography.sidebar)
                    .foregroundStyle(InquiroColors.textPrimary)
                    .lineLimit(1)
                Text(session.updated, style: .relative)
                    .font(InquiroTypography.timestamp)
                    .foregroundStyle(InquiroColors.textTertiary)
            }
        }
    }

    private func accentColor(for mode: SessionMode) -> Color {
        switch mode {
        case .chat: InquiroColors.chat
        case .research: InquiroColors.research
        case .brainstorm: InquiroColors.brainstorm
        }
    }

    private func createNewSession() {
        let project: Project
        if let first = projects.first {
            project = first
        } else {
            project = Project(name: "Default")
            modelContext.insert(project)
        }
        let session = Session(title: "New Chat", mode: .chat, project: project)
        modelContext.insert(session)
        try? modelContext.save()
        selectedSession = session
    }
}
