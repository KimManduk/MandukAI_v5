import SwiftUI

// MARK: - App Style

enum AppStyle: String, CaseIterable, Identifiable, Codable {
    case basic
    case jarvis
    case ios
    case game
    case mandukMix
    case cmd
    case dev

    var id: String { rawValue }

    var title: String {
        switch self {
        case .basic:
            return "A. 기본형"
        case .jarvis:
            return "B. Jarvis 미래형"
        case .ios:
            return "C. iOS 순정형"
        case .game:
            return "D. 게임 대시보드형"
        case .mandukMix:
            return "E. Manduk Mix"
        case .cmd:
            return "F. CMD 테마"
        case .dev:
            return "G. Dev 프로그래밍"
        }
    }

    var shortTitle: String {
        switch self {
        case .basic:
            return "기본형"
        case .jarvis:
            return "Jarvis"
        case .ios:
            return "iOS"
        case .game:
            return "게임형"
        case .mandukMix:
            return "Manduk Mix"
        case .cmd:
            return "CMD"
        case .dev:
            return "Dev"
        }
    }

    var description: String {
        switch self {
        case .basic:
            return "지금 스타일을 유지한 안정적인 카드형 UI"
        case .jarvis:
            return "어두운 배경과 네온 포인트가 있는 미래형 UI"
        case .ios:
            return "애플 기본 앱처럼 밝고 깔끔한 순정형 UI"
        case .game:
            return "큼직한 카드와 진행률이 강조되는 대시보드 UI"
        case .mandukMix:
            return "Jarvis 감성과 iOS 깔끔함을 섞은 추천 UI"
        case .cmd:
            return "검정 배경과 네온 그린 포인트의 터미널 UI"
        case .dev:
            return "코드 에디터 느낌의 블루/퍼플 개발자 UI"
        }
    }

    var systemImage: String {
        switch self {
        case .basic:
            return "square.grid.2x2.fill"
        case .jarvis:
            return "cpu.fill"
        case .ios:
            return "iphone"
        case .game:
            return "gamecontroller.fill"
        case .mandukMix:
            return "sparkles"
        case .cmd:
            return "terminal.fill"
        case .dev:
            return "chevron.left.forwardslash.chevron.right"
        }
    }
}

struct AppStylePalette: Equatable {
    var backgroundTop: Color
    var backgroundMiddle: Color
    var backgroundBottom: Color

    var primary: Color
    var secondary: Color
    var accent: Color

    var cardBackground: Color
    var cardStroke: Color
    var cardHighlight: Color

    var textPrimary: Color
    var textSecondary: Color
    var textTertiary: Color

    var success: Color
    var warning: Color
    var error: Color
    var info: Color
}

// MARK: - Manduk Theme

enum MandukTheme {

    // MARK: Style Palettes

    static func palette(for style: AppStyle) -> AppStylePalette {
        switch style {
        case .basic:
            return AppStylePalette(
                backgroundTop: Color(red: 0.06, green: 0.08, blue: 0.14),
                backgroundMiddle: Color(red: 0.08, green: 0.10, blue: 0.20),
                backgroundBottom: Color(red: 0.03, green: 0.04, blue: 0.08),
                primary: .blue,
                secondary: .purple,
                accent: .cyan,
                cardBackground: Color.white.opacity(0.10),
                cardStroke: Color.white.opacity(0.16),
                cardHighlight: Color.white.opacity(0.20),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.72),
                textTertiary: Color.white.opacity(0.48),
                success: .green,
                warning: .orange,
                error: .red,
                info: .blue
            )

        case .jarvis:
            return AppStylePalette(
                backgroundTop: Color(red: 0.01, green: 0.05, blue: 0.10),
                backgroundMiddle: Color(red: 0.02, green: 0.10, blue: 0.18),
                backgroundBottom: Color(red: 0.00, green: 0.02, blue: 0.05),
                primary: .cyan,
                secondary: .blue,
                accent: Color(red: 0.25, green: 0.95, blue: 1.00),
                cardBackground: Color.cyan.opacity(0.09),
                cardStroke: Color.cyan.opacity(0.24),
                cardHighlight: Color.cyan.opacity(0.20),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.76),
                textTertiary: Color.white.opacity(0.50),
                success: .green,
                warning: .orange,
                error: .red,
                info: .cyan
            )

        case .ios:
            return AppStylePalette(
                backgroundTop: Color(red: 0.96, green: 0.97, blue: 1.00),
                backgroundMiddle: Color(red: 0.94, green: 0.95, blue: 0.98),
                backgroundBottom: Color(red: 0.91, green: 0.93, blue: 0.97),
                primary: .blue,
                secondary: Color(red: 0.35, green: 0.38, blue: 0.45),
                accent: .mint,
                cardBackground: Color.white.opacity(0.82),
                cardStroke: Color.black.opacity(0.06),
                cardHighlight: Color.white.opacity(0.95),
                textPrimary: Color(red: 0.08, green: 0.09, blue: 0.12),
                textSecondary: Color(red: 0.35, green: 0.37, blue: 0.42),
                textTertiary: Color(red: 0.55, green: 0.57, blue: 0.62),
                success: .green,
                warning: .orange,
                error: .red,
                info: .blue
            )

        case .game:
            return AppStylePalette(
                backgroundTop: Color(red: 0.10, green: 0.04, blue: 0.16),
                backgroundMiddle: Color(red: 0.17, green: 0.08, blue: 0.27),
                backgroundBottom: Color(red: 0.04, green: 0.02, blue: 0.08),
                primary: Color(red: 0.65, green: 0.35, blue: 1.00),
                secondary: Color(red: 1.00, green: 0.35, blue: 0.75),
                accent: Color(red: 0.20, green: 1.00, blue: 0.70),
                cardBackground: Color.purple.opacity(0.12),
                cardStroke: Color.purple.opacity(0.28),
                cardHighlight: Color.white.opacity(0.18),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.76),
                textTertiary: Color.white.opacity(0.52),
                success: .green,
                warning: .yellow,
                error: .red,
                info: .purple
            )

        case .mandukMix:
            return AppStylePalette(
                backgroundTop: Color(red: 0.03, green: 0.07, blue: 0.13),
                backgroundMiddle: Color(red: 0.05, green: 0.10, blue: 0.18),
                backgroundBottom: Color(red: 0.88, green: 0.92, blue: 0.98),
                primary: .blue,
                secondary: .cyan,
                accent: .purple,
                cardBackground: Color.white.opacity(0.18),
                cardStroke: Color.white.opacity(0.22),
                cardHighlight: Color.white.opacity(0.34),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.78),
                textTertiary: Color.white.opacity(0.55),
                success: .green,
                warning: .orange,
                error: .red,
                info: .blue
            )

        case .cmd:
            return AppStylePalette(
                backgroundTop: Color(red: 0.04, green: 0.06, blue: 0.05),
                backgroundMiddle: Color(red: 0.07, green: 0.10, blue: 0.08),
                backgroundBottom: Color(red: 0.02, green: 0.04, blue: 0.03),
                primary: Color(red: 0.00, green: 1.00, blue: 0.53),
                secondary: Color(red: 0.20, green: 0.95, blue: 0.40),
                accent: Color(red: 0.55, green: 1.00, blue: 0.68),
                cardBackground: Color(red: 0.07, green: 0.10, blue: 0.08).opacity(0.88),
                cardStroke: Color(red: 0.00, green: 1.00, blue: 0.53).opacity(0.35),
                cardHighlight: Color(red: 0.12, green: 0.17, blue: 0.13).opacity(0.82),
                textPrimary: Color(red: 0.90, green: 0.97, blue: 0.92),
                textSecondary: Color(red: 0.65, green: 0.70, blue: 0.67),
                textTertiary: Color(red: 0.46, green: 0.52, blue: 0.49),
                success: Color(red: 0.00, green: 1.00, blue: 0.53),
                warning: .orange,
                error: .red,
                info: Color(red: 0.00, green: 1.00, blue: 0.53)
            )

        case .dev:
            return AppStylePalette(
                backgroundTop: Color(red: 0.05, green: 0.07, blue: 0.13),
                backgroundMiddle: Color(red: 0.07, green: 0.10, blue: 0.18),
                backgroundBottom: Color(red: 0.03, green: 0.04, blue: 0.07),
                primary: Color(red: 0.35, green: 0.65, blue: 1.00),
                secondary: Color(red: 0.64, green: 0.22, blue: 0.97),
                accent: Color(red: 0.58, green: 0.44, blue: 1.00),
                cardBackground: Color(red: 0.09, green: 0.11, blue: 0.15).opacity(0.88),
                cardStroke: Color(red: 0.39, green: 0.48, blue: 0.95).opacity(0.34),
                cardHighlight: Color(red: 0.13, green: 0.17, blue: 0.24).opacity(0.84),
                textPrimary: Color(red: 0.90, green: 0.93, blue: 0.95),
                textSecondary: Color(red: 0.55, green: 0.60, blue: 0.66),
                textTertiary: Color(red: 0.43, green: 0.47, blue: 0.53),
                success: .green,
                warning: .orange,
                error: .red,
                info: Color(red: 0.35, green: 0.65, blue: 1.00)
            )
        }
    }

    static let defaultStyle: AppStyle = .mandukMix

    // MARK: Colors

    enum Colors {
        private static var palette: AppStylePalette {
            MandukTheme.palette(for: MandukTheme.defaultStyle)
        }

        static var backgroundTop: Color { palette.backgroundTop }
        static var backgroundMiddle: Color { palette.backgroundMiddle }
        static var backgroundBottom: Color { palette.backgroundBottom }

        static var primary: Color { palette.primary }
        static var secondary: Color { palette.secondary }
        static var accent: Color { palette.accent }

        static var cardBackground: Color { palette.cardBackground }
        static var cardStroke: Color { palette.cardStroke }
        static var cardHighlight: Color { palette.cardHighlight }

        static var textPrimary: Color { palette.textPrimary }
        static var textSecondary: Color { palette.textSecondary }
        static var textTertiary: Color { palette.textTertiary }

        static var success: Color { palette.success }
        static var warning: Color { palette.warning }
        static var error: Color { palette.error }
        static var info: Color { palette.info }
    }

    // MARK: Spacing

    enum Spacing {
        static let xSmall: CGFloat = 6
        static let small: CGFloat = 10
        static let medium: CGFloat = 14
        static let large: CGFloat = 18
        static let xLarge: CGFloat = 24
        static let xxLarge: CGFloat = 32
    }

    // MARK: Radius

    enum Radius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 16
        static let large: CGFloat = 22
        static let xLarge: CGFloat = 28
        static let pill: CGFloat = 999
    }

    // MARK: Size

    enum Size {
        static let iconSmall: CGFloat = 18
        static let iconMedium: CGFloat = 24
        static let iconLarge: CGFloat = 34
        static let buttonHeight: CGFloat = 52
        static let tabBarHeight: CGFloat = 68
    }

    // MARK: Shadow

    enum Shadow {
        static let cardRadius: CGFloat = 18
        static let cardY: CGFloat = 10
        static let buttonRadius: CGFloat = 14
        static let buttonY: CGFloat = 8
    }

    // MARK: Gradients

    static var backgroundGradient: LinearGradient {
        backgroundGradient(for: defaultStyle)
    }

    static func backgroundGradient(for style: AppStyle) -> LinearGradient {
        let palette = palette(for: style)

        return LinearGradient(
            colors: [
                palette.backgroundTop,
                palette.backgroundMiddle,
                palette.backgroundBottom
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var primaryGradient: LinearGradient {
        primaryGradient(for: defaultStyle)
    }

    static func primaryGradient(for style: AppStyle) -> LinearGradient {
        let palette = palette(for: style)

        return LinearGradient(
            colors: [
                palette.primary,
                palette.secondary
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var accentGradient: LinearGradient {
        accentGradient(for: defaultStyle)
    }

    static func accentGradient(for style: AppStyle) -> LinearGradient {
        let palette = palette(for: style)

        return LinearGradient(
            colors: [
                palette.accent,
                palette.primary
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - View Helpers

extension View {
    func mandukCardStyle() -> some View {
        self
            .padding(MandukTheme.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous)
                    .fill(MandukTheme.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous)
                            .stroke(MandukTheme.Colors.cardStroke, lineWidth: 1)
                    )
                    .shadow(
                        color: .black.opacity(0.18),
                        radius: MandukTheme.Shadow.cardRadius,
                        x: 0,
                        y: MandukTheme.Shadow.cardY
                    )
            )
    }

    func mandukSectionPadding() -> some View {
        self
            .padding(.horizontal, MandukTheme.Spacing.large)
            .padding(.vertical, MandukTheme.Spacing.medium)
    }
}
