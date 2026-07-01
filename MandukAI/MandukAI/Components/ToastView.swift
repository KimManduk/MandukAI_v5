import SwiftUI

struct ToastView: View {
    let toast: AppToast
    var onClose: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: toast.type.systemImage)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(toast.type.tint)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(toast.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                if let message = toast.message, !message.isEmpty {
                    Text(message)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 8)

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary)
                    .frame(width: 28, height: 28)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("알림 닫기")
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(toast.type.tint.opacity(0.25), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.14), radius: 16, x: 0, y: 8)
        .padding(.horizontal, 16)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct ToastModifier: ViewModifier {
    @EnvironmentObject private var appState: AppState

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast = appState.toast {
                    ToastView(toast: toast) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            appState.clearToast()
                        }
                    }
                    .padding(.top, 10)
                    .zIndex(100)
                    .onAppear {
                        autoDismissToast(toast)
                    }
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: appState.toast)
    }

    private func autoDismissToast(_ toast: AppToast) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_500_000_000)

            if appState.toast?.id == toast.id {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    appState.clearToast()
                }
            }
        }
    }
}

extension View {
    func appToast() -> some View {
        modifier(ToastModifier())
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.blue.opacity(0.25), .purple.opacity(0.18)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        ToastView(
            toast: AppToast(
                title: "저장 완료",
                message: "프로젝트가 안전하게 저장됐어.",
                type: .success
            ),
            onClose: {}
        )
    }
}
