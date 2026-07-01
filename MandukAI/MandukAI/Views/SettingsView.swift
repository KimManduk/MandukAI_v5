import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showingResetAlert = false
    @State private var apiKeyInput: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        currentStyleBanner
                        profileSection
                        openAISection
                        appearanceSection
                        uiStyleSection
                        dataSection
                        appInfoSection
                    }
                    .padding(20)
                    .padding(.bottom, 90)
                }
            }
            .navigationTitle("설정")
            .toolbarBackground(.hidden, for: .navigationBar)
            .alert("전체 데이터를 초기화할까?", isPresented: $showingResetAlert) {
                Button("취소", role: .cancel) { }
                Button("초기화", role: .destructive) {
                    appState.resetAllData()
                }
            } message: {
                Text("프로젝트, 채팅, 메모, 테마 설정이 기본값으로 돌아가. 이 작업은 되돌릴 수 없어.")
            }
        }
    }

    // MARK: - Current Style

    private var currentStyleBanner: some View {
        let palette = appState.currentPalette

        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                        .frame(width: 64, height: 64)
                        .shadow(color: palette.primary.opacity(0.38), radius: 18, x: 0, y: 8)

                    Image(systemName: appState.selectedStyle.systemImage)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("현재 UI 스타일")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(palette.primary)

                    Text(appState.selectedStyle.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(textColor)

                    Text(appState.selectedStyle.description)
                        .font(.caption)
                        .foregroundStyle(subTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            stylePreviewLarge
        }
        .padding(18)
        .background(cardBackground(cornerRadius: 26))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(palette.cardStroke, lineWidth: 1.3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: shadowColor, radius: appState.selectedStyle == .ios ? 8 : 16, x: 0, y: 8)
    }

    // MARK: - Profile

    private var profileSection: some View {
        settingCard(title: "프로필", systemImage: "person.crop.circle.fill") {
            VStack(spacing: 14) {
                textFieldRow(
                    title: "사용자 이름",
                    placeholder: "사용자 이름",
                    text: Binding(
                        get: { appState.userName },
                        set: { appState.updateUserName($0) }
                    )
                )

                divider

                textFieldRow(
                    title: "AI 이름",
                    placeholder: "AI 이름",
                    text: Binding(
                        get: { appState.assistantName },
                        set: { appState.updateAssistantName($0) }
                    )
                )
            }
        }
    }

    // MARK: - OpenAI

    private var openAISection: some View {
        settingCard(title: "OpenAI 연결", systemImage: "sparkles") {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    Image(systemName: appState.openAIAPIKey.isEmpty ? "exclamationmark.triangle.fill" : "checkmark.seal.fill")
                        .foregroundStyle(appState.openAIAPIKey.isEmpty ? .orange : .green)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(appState.openAIAPIKey.isEmpty ? "API 키가 필요해" : "API 키 저장됨")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(textColor)

                        Text(appState.openAIAPIKey.isEmpty ? "키를 저장하면 AI 채팅이 실제 OpenAI로 연결돼." : "이제 AI 채팅에서 실제 답변을 테스트할 수 있어.")
                            .font(.caption)
                            .foregroundStyle(subTextColor)
                    }

                    Spacer(minLength: 0)
                }

                divider

                VStack(alignment: .leading, spacing: 8) {
                    Text("API 키")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(subTextColor)

                    SecureField("sk-...", text: $apiKeyInput)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundStyle(textColor)
                        .padding(12)
                        .background(fieldBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
                        )
                }

                HStack(spacing: 10) {
                    Button {
                        appState.updateOpenAIAPIKey(apiKeyInput)
                        apiKeyInput = ""
                    } label: {
                        Label("저장", systemImage: "key.fill")
                            .font(.subheadline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .background(appState.currentPalette.primary)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    Button(role: .destructive) {
                        appState.updateOpenAIAPIKey("")
                        apiKeyInput = ""
                    } label: {
                        Label("삭제", systemImage: "trash.fill")
                            .font(.subheadline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .background(Color.red.opacity(appState.selectedStyle == .ios ? 0.10 : 0.14))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }

                Text("API 키는 이 앱의 UserDefaults에 저장돼. 테스트용으로만 사용하고, 배포용 앱에서는 서버를 통해 숨기는 방식이 더 안전해.")
                    .font(.caption2)
                    .foregroundStyle(subTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .onAppear {
            apiKeyInput = appState.openAIAPIKey
        }
    }

    private func textFieldRow(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(subTextColor)

            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(textColor)
                .padding(12)
                .background(fieldBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
                )
        }
    }

    // MARK: - Appearance

    private var appearanceSection: some View {
        settingCard(title: "화면", systemImage: "moon.stars.fill") {
            VStack(alignment: .leading, spacing: 10) {
                Text("테마")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)

                HStack(spacing: 8) {
                    ForEach(AppTheme.allCases) { theme in
                        themeButton(theme)
                    }
                }
            }
        }
    }

    private func themeButton(_ theme: AppTheme) -> some View {
        let isSelected = appState.theme == theme
        let palette = appState.currentPalette

        return Button {
            appState.theme = theme
        } label: {
            Text(theme.title)
                .font(.caption.weight(.bold))
                .foregroundStyle(isSelected ? .white : textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(isSelected ? palette.primary : palette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.75 : 0.25))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? palette.primary.opacity(0.9) : palette.cardStroke, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - UI Style

    private var uiStyleSection: some View {
        settingCard(title: "UI 스타일", systemImage: "paintpalette.fill") {
            VStack(alignment: .leading, spacing: 12) {
                Text("버튼을 누르면 설정 화면 배경과 카드까지 바로 바뀌어.")
                    .font(.caption)
                    .foregroundStyle(subTextColor)

                VStack(spacing: 10) {
                    ForEach(AppStyle.allCases) { style in
                        styleButton(style)
                    }
                }
            }
        }
    }

    private func styleButton(_ style: AppStyle) -> some View {
        let isSelected = appState.selectedStyle == style
        let palette = MandukTheme.palette(for: style)

        return Button {
            appState.updateSelectedStyle(style)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    palette.primary,
                                    palette.secondary,
                                    palette.accent.opacity(0.85)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: palette.primary.opacity(isSelected ? 0.28 : 0.08), radius: 10, x: 0, y: 5)

                    Image(systemName: style.systemImage)
                        .font(.system(size: 21, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(style.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(textColor)

                    Text(style.description)
                        .font(.caption)
                        .foregroundStyle(subTextColor)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? appState.currentPalette.primary : subTextColor.opacity(0.65))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.12 : 0.18) : appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.55 : 0.18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(isSelected ? appState.currentPalette.primary.opacity(0.65) : appState.currentPalette.cardStroke, lineWidth: isSelected ? 1.5 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var stylePreviewLarge: some View {
        let palette = appState.currentPalette

        return HStack(spacing: 8) {
            previewBlock(color: palette.backgroundTop, title: "상단")
            previewBlock(color: palette.primary, title: "메인")
            previewBlock(color: palette.secondary, title: "보조")
            previewBlock(color: palette.accent, title: "포인트")
            previewBlock(color: palette.cardBackground, title: "카드")
        }
    }

    private func previewBlock(color: Color, title: String) -> some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(color)
                .frame(height: 34)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.primary.opacity(0.10), lineWidth: 1)
                )

            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Data

    private var dataSection: some View {
        settingCard(title: "데이터", systemImage: "externaldrive.fill") {
            VStack(spacing: 12) {
                infoRow(title: "저장된 프로젝트", value: "\(appState.projects.count)개", systemImage: "folder.fill")
                divider
                infoRow(title: "저장된 채팅", value: "\(appState.chatMessages.count)개", systemImage: "bubble.left.and.bubble.right.fill")
                divider
                infoRow(title: "저장된 메모", value: "\(appState.quickMemos.count)개", systemImage: "note.text")
                divider

                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    HStack {
                        Label("전체 초기화", systemImage: "trash.fill")
                            .font(.subheadline.weight(.bold))

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.red.opacity(appState.selectedStyle == .ios ? 0.10 : 0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
    }

    // MARK: - App Info

    private var appInfoSection: some View {
        settingCard(title: "앱 정보", systemImage: "info.circle.fill") {
            VStack(spacing: 12) {
                infoRow(title: "앱 이름", value: "MandukAI", systemImage: "app.fill")
                divider
                infoRow(title: "버전", value: "v5 Sprint 1C", systemImage: "number.circle.fill")
                divider
                infoRow(title: "상태", value: appState.openAIAPIKey.isEmpty ? "AI 카메라 / 빠른 메모 작동 중" : "OpenAI 채팅 / AI 카메라 / 빠른 메모 작동 중", systemImage: "checkmark.seal.fill")
            }
        }
    }

    private func infoRow(title: String, value: String, systemImage: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(appState.currentPalette.primary)
                .frame(width: 24)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(textColor)

            Spacer(minLength: 8)

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(subTextColor)
                .multilineTextAlignment(.trailing)
        }
    }

    // MARK: - Common

    private func settingCard<Content: View>(
        title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .foregroundStyle(appState.currentPalette.primary)

                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(textColor)
            }

            content()
        }
        .padding(16)
        .background(cardBackground(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(appState.currentPalette.cardStroke, lineWidth: appState.selectedStyle == .game ? 1.4 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: shadowColor, radius: appState.selectedStyle == .ios ? 7 : 14, x: 0, y: appState.selectedStyle == .ios ? 4 : 8)
    }

    private var divider: some View {
        Rectangle()
            .fill(appState.currentPalette.cardStroke)
            .frame(height: 1)
            .opacity(appState.selectedStyle == .ios ? 0.55 : 0.35)
    }

    private var textColor: Color {
        appState.currentPalette.textPrimary
    }

    private var subTextColor: Color {
        appState.currentPalette.textSecondary
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.72 : 0.22))
    }

    private func cardBackground(cornerRadius: CGFloat) -> some View {
        let palette = appState.currentPalette

        return RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        palette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.94 : 0.40),
                        palette.cardBackground.opacity(appState.selectedStyle == .ios ? 0.86 : 0.72),
                        palette.primary.opacity(appState.selectedStyle == .ios ? 0.05 : 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private var shadowColor: Color {
        switch appState.selectedStyle {
        case .basic:
            return Color.black.opacity(0.12)
        case .jarvis:
            return Color.cyan.opacity(0.18)
        case .ios:
            return Color.black.opacity(0.05)
        case .game:
            return Color.purple.opacity(0.22)
        case .mandukMix:
            return Color.blue.opacity(0.14)
        case .cmd:
            return Color.green.opacity(0.16)
        case .dev:
            return Color.blue.opacity(0.16)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
