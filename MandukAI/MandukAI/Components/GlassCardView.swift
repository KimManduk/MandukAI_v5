import SwiftUI

struct GlassCardView<Content: View>: View {
    @EnvironmentObject private var appState: AppState

    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let content: Content

    init(
        cornerRadius: CGFloat = 22,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        let palette = appState.currentPalette

        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground(for: appState.selectedStyle, palette: palette))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(palette.cardStroke, lineWidth: borderWidth(for: appState.selectedStyle))
            )
            .shadow(
                color: shadowColor(for: appState.selectedStyle),
                radius: shadowRadius(for: appState.selectedStyle),
                x: 0,
                y: shadowY(for: appState.selectedStyle)
            )
    }

    private func cardBackground(for style: AppStyle, palette: AppStylePalette) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(backgroundFill(for: style, palette: palette))
    }

    private func backgroundFill(for style: AppStyle, palette: AppStylePalette) -> LinearGradient {
        switch style {
        case .basic:
            return LinearGradient(
                colors: [
                    palette.cardBackground,
                    palette.cardHighlight.opacity(0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .jarvis:
            return LinearGradient(
                colors: [
                    palette.cardBackground,
                    palette.primary.opacity(0.06),
                    Color.black.opacity(0.16)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .ios:
            return LinearGradient(
                colors: [
                    palette.cardBackground,
                    palette.cardHighlight
                ],
                startPoint: .top,
                endPoint: .bottom
            )

        case .game:
            return LinearGradient(
                colors: [
                    palette.cardBackground,
                    palette.secondary.opacity(0.13),
                    Color.black.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .mandukMix:
            return LinearGradient(
                colors: [
                    palette.cardHighlight.opacity(0.72),
                    palette.cardBackground,
                    palette.primary.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .cmd:
            return LinearGradient(
                colors: [
                    palette.cardBackground,
                    palette.primary.opacity(0.08),
                    Color.black.opacity(0.20)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .dev:
            return LinearGradient(
                colors: [
                    palette.cardHighlight.opacity(0.72),
                    palette.cardBackground,
                    palette.secondary.opacity(0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private func borderWidth(for style: AppStyle) -> CGFloat {
        switch style {
        case .basic:
            return 1
        case .jarvis:
            return 1.4
        case .ios:
            return 0.8
        case .game:
            return 1.6
        case .mandukMix:
            return 1.2
        case .cmd:
            return 1.4
        case .dev:
            return 1.4
        }
    }

    private func shadowColor(for style: AppStyle) -> Color {
        switch style {
        case .basic:
            return Color.black.opacity(0.14)
        case .jarvis:
            return Color.cyan.opacity(0.22)
        case .ios:
            return Color.black.opacity(0.07)
        case .game:
            return Color.purple.opacity(0.26)
        case .mandukMix:
            return Color.blue.opacity(0.18)
        case .cmd:
            return Color.green.opacity(0.18)
        case .dev:
            return Color.blue.opacity(0.16)
        }
    }

    private func shadowRadius(for style: AppStyle) -> CGFloat {
        switch style {
        case .basic:
            return 14
        case .jarvis:
            return 20
        case .ios:
            return 12
        case .game:
            return 22
        case .mandukMix:
            return 18
        case .cmd:
            return 18
        case .dev:
            return 18
        }
    }

    private func shadowY(for style: AppStyle) -> CGFloat {
        switch style {
        case .basic:
            return 8
        case .jarvis:
            return 10
        case .ios:
            return 6
        case .game:
            return 10
        case .mandukMix:
            return 8
        case .cmd:
            return 8
        case .dev:
            return 8
        }
    }
}

struct GlassIconView: View {
    @EnvironmentObject private var appState: AppState

    var systemImage: String
    var tint: Color?
    var size: CGFloat

    init(
        systemImage: String,
        tint: Color? = nil,
        size: CGFloat = 44
    ) {
        self.systemImage = systemImage
        self.tint = tint
        self.size = size
    }

    var body: some View {
        let palette = appState.currentPalette
        let iconTint = tint ?? palette.primary

        Image(systemName: systemImage)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(iconTint)
            .frame(width: size, height: size)
            .background(iconBackground(tint: iconTint, palette: palette))
            .clipShape(RoundedRectangle(cornerRadius: size * 0.32, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: size * 0.32, style: .continuous)
                    .stroke(iconTint.opacity(appState.selectedStyle == .ios ? 0.12 : 0.26), lineWidth: 1)
            )
    }

    private func iconBackground(tint: Color, palette: AppStylePalette) -> some View {
        LinearGradient(
            colors: [
                tint.opacity(appState.selectedStyle == .ios ? 0.10 : 0.20),
                palette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.65 : 0.20)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        GlassCardView {
            HStack(spacing: 12) {
                GlassIconView(systemImage: "sparkles")

                VStack(alignment: .leading, spacing: 4) {
                    Text("MandukAI")
                        .font(.headline)

                    Text("공통 카드 미리보기")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    .padding()
    .background(MandukTheme.backgroundGradient(for: .mandukMix))
    .environmentObject(AppState())
}
