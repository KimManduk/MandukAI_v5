import SwiftUI

struct EmptyStateView: View {
    var systemImage: String
    var title: String
    var message: String
    var buttonTitle: String?
    var buttonSystemImage: String?
    var action: (() -> Void)?

    init(
        systemImage: String = "tray",
        title: String,
        message: String,
        buttonTitle: String? = nil,
        buttonSystemImage: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonSystemImage = buttonSystemImage
        self.action = action
    }

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: systemImage)
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 84, height: 84)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            if let buttonTitle, let action {
                Button(action: action) {
                    HStack(spacing: 8) {
                        if let buttonSystemImage {
                            Image(systemName: buttonSystemImage)
                                .font(.system(size: 14, weight: .semibold))
                        }

                        Text(buttonTitle)
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(buttonTitle)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 20) {
        EmptyStateView(
            systemImage: "folder.badge.plus",
            title: "아직 프로젝트가 없어",
            message: "첫 번째 프로젝트를 추가해서 MandukAI 작업을 시작해보자.",
            buttonTitle: "프로젝트 추가",
            buttonSystemImage: "plus"
        ) {}

        EmptyStateView(
            systemImage: "bubble.left.and.bubble.right",
            title: "대화가 비어있어",
            message: "아래 입력창에 메시지를 입력하면 대화가 시작돼."
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
