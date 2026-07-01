import SwiftUI

struct ChatBubbleView: View {
    @EnvironmentObject private var appState: AppState

    let message: MandukChatMessage

    private var isUser: Bool {
        message.role == .user
    }

    private var isSystem: Bool {
        message.role == .system
    }

    var body: some View {
        if isSystem {
            systemBubble
        } else {
            normalBubble
        }
    }

    private var normalBubble: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser {
                Spacer(minLength: 44)
            } else {
                avatar
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 6) {
                Text(message.content)
                    .font(.body)
                    .foregroundStyle(isUser ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(bubbleBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                HStack(spacing: 8) {
                    Text(message.createdAt, style: .time)
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    if !isUser {
                        Button {
                            saveAssistantMessageToMemo()
                        } label: {
                            Label("메모 저장", systemImage: "note.text.badge.plus")
                                .font(.caption2.weight(.semibold))
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal, 4)
            }

            if isUser {
                avatar
            } else {
                Spacer(minLength: 44)
            }
        }
    }

    private func saveAssistantMessageToMemo() {
        let trimmedContent = message.content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }

        let title: String
        if trimmedContent.count > 18 {
            let prefixText = String(trimmedContent.prefix(18))
            title = "AI 답변: \(prefixText)..."
        } else {
            title = "AI 답변: \(trimmedContent)"
        }

        let category: QuickMemoCategory
        if trimmedContent.contains("```") ||
            trimmedContent.contains("swift") ||
            trimmedContent.contains("코드") ||
            trimmedContent.contains("파일") {
            category = .code
        } else {
            category = .note
        }

        appState.addQuickMemo(
            title: title,
            content: trimmedContent,
            category: category
        )
    }

    private var systemBubble: some View {
        HStack {
            Spacer(minLength: 24)

            HStack(spacing: 6) {
                Image(systemName: "info.circle.fill")
                    .font(.caption)

                Text(message.content)
                    .font(.caption)
                    .lineLimit(nil)
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )

            Spacer(minLength: 24)
        }
    }

    private var avatar: some View {
        ZStack {
            Circle()
                .fill(isUser ? Color.blue.opacity(0.15) : Color.purple.opacity(0.15))
                .frame(width: 32, height: 32)

            Image(systemName: isUser ? "person.fill" : "sparkles")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isUser ? .blue : .purple)
        }
    }

    private var bubbleBackground: some ShapeStyle {
        if isUser {
            return AnyShapeStyle(Color.blue)
        } else {
            return AnyShapeStyle(Color(.secondarySystemBackground))
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ChatBubbleView(
            message: MandukChatMessage(
                role: .assistant,
                content: "안녕, 나는 만덕 AI야. 오늘 만들 기능을 말해줘!"
            )
        )

        ChatBubbleView(
            message: MandukChatMessage(
                role: .user,
                content: "Sprint 1A 계속 가자"
            )
        )

        ChatBubbleView(
            message: MandukChatMessage(
                role: .system,
                content: "채팅이 저장됐어."
            )
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .environmentObject(AppState())
}
