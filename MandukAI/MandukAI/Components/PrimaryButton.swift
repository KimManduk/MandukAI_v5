import SwiftUI

struct PrimaryButton: View {
    var title: String
    var systemImage: String?
    var isLoading: Bool
    var isDisabled: Bool
    var action: () -> Void

    init(
        _ title: String,
        systemImage: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: {
            guard !isLoading && !isDisabled else { return }
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 15, weight: .semibold))
                }

                Text(title)
                    .font(.system(size: 16, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(.white)
            .background(
                LinearGradient(
                    colors: buttonColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(
                color: .blue.opacity(isDisabled ? 0 : 0.28),
                radius: 14,
                x: 0,
                y: 8
            )
            .opacity(isDisabled ? 0.45 : 1)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled || isLoading)
        .accessibilityLabel(title)
    }

    private var buttonColors: [Color] {
        if isDisabled {
            return [.gray, .gray.opacity(0.75)]
        }

        return [
            Color.blue,
            Color.purple
        ]
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton("저장하기", systemImage: "checkmark") {}

        PrimaryButton("생성 중", systemImage: "sparkles", isLoading: true) {}

        PrimaryButton("비활성화", systemImage: "lock.fill", isDisabled: true) {}
    }
    .padding()
}
