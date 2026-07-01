import SwiftUI

// MARK: - App Background

struct AppBackgroundView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        let style = appState.selectedStyle
        let palette = appState.currentPalette

        ZStack {
            MandukTheme.backgroundGradient(for: style)
                .ignoresSafeArea()

            backgroundEffects(for: style, palette: palette)
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func backgroundEffects(for style: AppStyle, palette: AppStylePalette) -> some View {
        switch style {
        case .basic:
            basicEffects(palette: palette)

        case .jarvis:
            jarvisEffects(palette: palette)

        case .ios:
            iosEffects(palette: palette)

        case .game:
            gameEffects(palette: palette)

        case .mandukMix:
            mandukMixEffects(palette: palette)

        case .cmd:
            cmdEffects(palette: palette)

        case .dev:
            devEffects(palette: palette)
        }
    }

    private func basicEffects(palette: AppStylePalette) -> some View {
        ZStack {
            Circle()
                .fill(palette.primary.opacity(0.16))
                .frame(width: 260, height: 260)
                .blur(radius: 44)
                .offset(x: 120, y: -210)

            Circle()
                .fill(palette.secondary.opacity(0.13))
                .frame(width: 230, height: 230)
                .blur(radius: 46)
                .offset(x: -130, y: 330)
        }
    }

    private func jarvisEffects(palette: AppStylePalette) -> some View {
        ZStack {
            Circle()
                .stroke(palette.primary.opacity(0.32), lineWidth: 1.4)
                .frame(width: 360, height: 360)
                .blur(radius: 0.4)
                .offset(x: 150, y: -220)

            Circle()
                .stroke(palette.accent.opacity(0.22), lineWidth: 1)
                .frame(width: 240, height: 240)
                .offset(x: 150, y: -220)

            Circle()
                .fill(palette.primary.opacity(0.18))
                .frame(width: 180, height: 180)
                .blur(radius: 34)
                .offset(x: 150, y: -220)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            palette.primary.opacity(0.12),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .offset(y: -120)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            palette.primary.opacity(0.08),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .offset(y: 40)

            Circle()
                .fill(palette.secondary.opacity(0.14))
                .frame(width: 230, height: 230)
                .blur(radius: 48)
                .offset(x: -140, y: 320)
        }
    }

    private func iosEffects(palette: AppStylePalette) -> some View {
        ZStack {
            Circle()
                .fill(palette.primary.opacity(0.10))
                .frame(width: 300, height: 300)
                .blur(radius: 54)
                .offset(x: 120, y: -210)

            Circle()
                .fill(palette.accent.opacity(0.12))
                .frame(width: 260, height: 260)
                .blur(radius: 58)
                .offset(x: -140, y: 310)

            Circle()
                .fill(Color.white.opacity(0.28))
                .frame(width: 160, height: 160)
                .blur(radius: 30)
                .offset(x: 20, y: 120)
        }
    }

    private func gameEffects(palette: AppStylePalette) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 42, style: .continuous)
                .stroke(palette.secondary.opacity(0.26), lineWidth: 2)
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(18))
                .blur(radius: 0.5)
                .offset(x: 150, y: -210)

            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .stroke(palette.accent.opacity(0.18), lineWidth: 1.5)
                .frame(width: 190, height: 190)
                .rotationEffect(.degrees(-14))
                .offset(x: -150, y: 320)

            Circle()
                .fill(palette.secondary.opacity(0.20))
                .frame(width: 240, height: 240)
                .blur(radius: 48)
                .offset(x: 145, y: -210)

            Circle()
                .fill(palette.accent.opacity(0.14))
                .frame(width: 210, height: 210)
                .blur(radius: 44)
                .offset(x: -140, y: 310)
        }
    }

    private func mandukMixEffects(palette: AppStylePalette) -> some View {
        ZStack {
            Circle()
                .stroke(palette.secondary.opacity(0.22), lineWidth: 1.2)
                .frame(width: 320, height: 320)
                .offset(x: 140, y: -220)

            Circle()
                .fill(palette.primary.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 48)
                .offset(x: 130, y: -210)

            Circle()
                .fill(palette.accent.opacity(0.13))
                .frame(width: 230, height: 230)
                .blur(radius: 52)
                .offset(x: -140, y: 320)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.10),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .offset(y: -95)
        }
    }

    private func cmdEffects(palette: AppStylePalette) -> some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            palette.primary.opacity(0.10),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .offset(y: -170)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            palette.primary.opacity(0.07),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .offset(y: 130)

            Circle()
                .fill(palette.primary.opacity(0.13))
                .frame(width: 250, height: 250)
                .blur(radius: 56)
                .offset(x: -150, y: 290)

            Circle()
                .stroke(palette.primary.opacity(0.20), lineWidth: 1)
                .frame(width: 300, height: 300)
                .offset(x: 150, y: -220)

            Text(">_")
                .font(.system(size: 72, weight: .bold, design: .monospaced))
                .foregroundStyle(palette.primary.opacity(0.10))
                .offset(x: -120, y: -250)
        }
    }

    private func devEffects(palette: AppStylePalette) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .stroke(palette.primary.opacity(0.22), lineWidth: 1.3)
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(12))
                .offset(x: 145, y: -210)

            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(palette.secondary.opacity(0.22), lineWidth: 1.2)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-10))
                .offset(x: -150, y: 300)

            Circle()
                .fill(palette.primary.opacity(0.16))
                .frame(width: 260, height: 260)
                .blur(radius: 52)
                .offset(x: 130, y: -220)

            Circle()
                .fill(palette.secondary.opacity(0.13))
                .frame(width: 240, height: 240)
                .blur(radius: 54)
                .offset(x: -140, y: 315)

            Text("</>")
                .font(.system(size: 62, weight: .bold, design: .monospaced))
                .foregroundStyle(palette.primary.opacity(0.10))
                .offset(x: -125, y: -245)
        }
    }
}

// MARK: - Background Modifier

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AppBackgroundView()
            content
        }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
}

#Preview {
    VStack(spacing: 16) {
        Image(systemName: "sparkles")
            .font(.largeTitle)
        Text("MandukAI")
            .font(.title.bold())
        Text("공통 배경 미리보기")
            .foregroundStyle(.secondary)
    }
    .appBackground()
    .environmentObject(AppState())
}
