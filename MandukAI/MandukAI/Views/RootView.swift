import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            TabView(selection: $appState.selectedTab) {
                HomeView()
                    .tabItem {
                        Label(AppTab.home.title, systemImage: AppTab.home.systemImage)
                    }
                    .tag(AppTab.home)

                ChatView()
                    .tabItem {
                        Label(AppTab.chat.title, systemImage: AppTab.chat.systemImage)
                    }
                    .tag(AppTab.chat)

                ProjectsView()
                    .tabItem {
                        Label(AppTab.projects.title, systemImage: AppTab.projects.systemImage)
                    }
                    .tag(AppTab.projects)

                ToolsView()
                    .tabItem {
                        Label(AppTab.tools.title, systemImage: AppTab.tools.systemImage)
                    }
                    .tag(AppTab.tools)

                SettingsView()
                    .tabItem {
                        Label(AppTab.settings.title, systemImage: AppTab.settings.systemImage)
                    }
                    .tag(AppTab.settings)
            }
            .preferredColorScheme(appState.theme.colorScheme)

            if appState.isLoading {
                LoadingOverlayView()
            }

            if let toast = appState.toast {
                ToastOverlayView(toast: toast) {
                    appState.clearToast()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(10)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: appState.toast)
        .animation(.easeInOut(duration: 0.2), value: appState.isLoading)
    }
}

// MARK: - Loading Overlay

private struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                ProgressView()
                    .scaleEffect(1.2)

                Text("처리 중...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(radius: 20)
        }
    }
}

// MARK: - Toast Overlay

private struct ToastOverlayView: View {
    let toast: AppToast
    let onClose: () -> Void

    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: toast.type.systemImage)
                    .font(.title3)
                    .foregroundStyle(toast.type.tint)

                VStack(alignment: .leading, spacing: 4) {
                    Text(toast.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)

                    if let message = toast.message, !message.isEmpty {
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer(minLength: 8)

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .padding(6)
                }
                .buttonStyle(.plain)
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(radius: 14)
            .padding(.horizontal, 16)
            .padding(.top, 12)

            Spacer()
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
