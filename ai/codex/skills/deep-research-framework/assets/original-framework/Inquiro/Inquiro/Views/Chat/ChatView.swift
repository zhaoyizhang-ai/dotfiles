import SwiftUI
import SwiftData

struct ChatView: View {
    let session: Session
    @Bindable var viewModel: ChatViewModel
    @Bindable private var settings = AppSettings.shared
    @State private var inputText = ""

    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: InquiroSpacing.lg) {
                        ForEach(session.sortedMessages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }

                        // Streaming message
                        if viewModel.isStreaming && !viewModel.streamingContent.isEmpty {
                            streamingBubble
                                .id("streaming")
                        }

                        // Error
                        if let error = viewModel.errorMessage {
                            errorBanner(error)
                        }
                    }
                    .padding(.horizontal, InquiroSpacing.xl)
                    .padding(.vertical, InquiroSpacing.lg)
                    .frame(maxWidth: InquiroTypography.maxContentWidth)
                    .frame(maxWidth: .infinity)
                }
                .onChange(of: viewModel.streamingContent) {
                    proxy.scrollTo("streaming", anchor: .bottom)
                }
                .onChange(of: session.messages.count) {
                    if let last = session.sortedMessages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            // Input
            InputBarView(
                text: $inputText,
                isStreaming: viewModel.isStreaming,
                onSend: sendMessage,
                onCancel: { viewModel.cancelStream() }
            )
        }
        .background(InquiroColors.background)
        .onAppear {
            viewModel.session = session
        }
        .onChange(of: session) {
            viewModel.session = session
        }
    }

    private var streamingBubble: some View {
        HStack(alignment: .top, spacing: InquiroSpacing.md) {
            VStack(alignment: .leading, spacing: InquiroSpacing.xs) {
                Text(try! AttributedString(markdown: viewModel.streamingContent, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    .font(InquiroTypography.body)
                    .foregroundStyle(InquiroColors.textPrimary)
                    .lineSpacing(InquiroTypography.reportLineSpacing)
            }
            .padding(InquiroSpacing.md)
            Spacer(minLength: 80)
        }
    }

    private func errorBanner(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(InquiroColors.warning)
            Text(message)
                .font(InquiroTypography.body)
                .foregroundStyle(InquiroColors.warning)
        }
        .padding(InquiroSpacing.md)
        .background(InquiroColors.warning.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: InquiroSpacing.cardCornerRadius))
    }

    private func sendMessage() {
        let content = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }
        inputText = ""
        viewModel.send(
            content: content,
            model: settings.effectiveModel,
            settings: settings
        )
    }
}
