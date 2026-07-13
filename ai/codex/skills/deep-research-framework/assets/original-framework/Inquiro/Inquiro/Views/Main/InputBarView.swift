import SwiftUI

struct InputBarView: View {
    @Binding var text: String
    let isStreaming: Bool
    let onSend: () -> Void
    let onCancel: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: InquiroSpacing.md) {
            TextEditor(text: $text)
                .font(InquiroTypography.body)
                .foregroundStyle(InquiroColors.textPrimary)
                .scrollContentBackground(.hidden)
                .focused($isFocused)
                .frame(minHeight: 20, maxHeight: 120)
                .fixedSize(horizontal: false, vertical: true)
                .onSubmit {
                    if !NSEvent.modifierFlags.contains(.shift) {
                        onSend()
                    }
                }

            if isStreaming {
                Button {
                    onCancel()
                } label: {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(InquiroColors.warning)
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    onSend()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? InquiroColors.textTertiary
                            : InquiroColors.research)
                }
                .buttonStyle(.plain)
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(InquiroSpacing.md)
        .background(InquiroColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: InquiroSpacing.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: InquiroSpacing.cardCornerRadius)
                .stroke(InquiroColors.border, lineWidth: 1)
        )
        .padding(.horizontal, InquiroSpacing.lg)
        .padding(.bottom, InquiroSpacing.lg)
        .onAppear { isFocused = true }
    }
}
