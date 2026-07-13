import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let isStreaming: Bool

    init(message: Message, isStreaming: Bool = false) {
        self.message = message
        self.isStreaming = isStreaming
    }

    var body: some View {
        HStack(alignment: .top, spacing: InquiroSpacing.md) {
            if message.messageRole == .user {
                Spacer(minLength: 80)
            }

            VStack(alignment: message.messageRole == .user ? .trailing : .leading, spacing: InquiroSpacing.xs) {
                Text(try! AttributedString(markdown: message.content, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                    .font(InquiroTypography.body)
                    .foregroundStyle(InquiroColors.textPrimary)
                    .textSelection(.enabled)
                    .lineSpacing(InquiroTypography.reportLineSpacing)

                if let model = message.modelUsed {
                    Text(model)
                        .font(InquiroTypography.timestamp)
                        .foregroundStyle(InquiroColors.textTertiary)
                }
            }
            .padding(InquiroSpacing.md)
            .background(
                message.messageRole == .user
                    ? InquiroColors.surfaceAlt
                    : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: InquiroSpacing.cardCornerRadius))

            if message.messageRole == .assistant {
                Spacer(minLength: 80)
            }
        }
    }
}
