import SwiftUI

struct ToolsView: View {
    @EnvironmentObject private var appState: AppState

    private let tools: [MandukToolItem] = [
        MandukToolItem(
            title: "AI 카메라",
            subtitle: "사진을 분석하고 설명하는 기능",
            systemImage: "camera.viewfinder",
            status: "연결됨",
            tint: .blue
        ),
        MandukToolItem(
            title: "코드 저장소",
            subtitle: "내 코드와 프로젝트 메모를 저장",
            systemImage: "chevron.left.forwardslash.chevron.right",
            status: "준비 중",
            tint: .purple
        ),
        MandukToolItem(
            title: "쇼츠 메이커",
            subtitle: "대본, 장면, 이미지 프롬프트 관리",
            systemImage: "play.rectangle.fill",
            status: "준비 중",
            tint: .pink
        ),
        MandukToolItem(
            title: "원격 제어",
            subtitle: "만덕 Remote와 연결할 공간",
            systemImage: "desktopcomputer.and.arrow.down",
            status: "준비 중",
            tint: .cyan
        ),
        MandukToolItem(
            title: "빠른 메모",
            subtitle: "아이디어를 바로 적어두는 공간",
            systemImage: "note.text",
            status: "연결됨",
            tint: .green
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView(showsIndicators: false) {
                    Group {
                        switch appState.selectedStyle {
                        case .basic:
                            normalToolsInterface
                        case .jarvis:
                            jarvisToolsInterface
                        case .ios:
                            iosToolsInterface
                        case .game:
                            gameToolsInterface
                        case .mandukMix:
                            mandukToolsInterface
                        case .cmd:
                            cmdToolsInterface
                        case .dev:
                            devToolsInterface
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 90)
                }
            }
            .navigationTitle(navigationTitle)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var navigationTitle: String {
        switch appState.selectedStyle {
        case .basic:
            return "도구"
        case .jarvis:
            return "Tool Core"
        case .ios:
            return "Tools"
        case .game:
            return "Inventory"
        case .mandukMix:
            return "만덕 도구실"
        case .cmd:
            return "Commands"
        case .dev:
            return "ToolKit"
        }
    }

    // MARK: - Normal

    private var normalToolsInterface: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            styleStatusCard
            toolsSection(title: "연결된 도구", variant: .normal)
            sprintGoalSection
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("만덕 AI 도구실")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)

            Text("자주 쓰는 기능을 하나씩 붙여서 나만의 AI 앱으로 키워갈 공간이야.")
                .font(.subheadline)
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Jarvis

    private var jarvisToolsInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            jarvisToolHeader
            jarvisToolStats
            styleStatusCard
            toolsSection(title: "MODULE BAY", variant: .jarvis)
            sprintGoalSection
        }
    }

    private var jarvisToolHeader: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(appState.currentPalette.primary.opacity(0.18), lineWidth: 16)
                    .frame(width: 132, height: 132)

                Circle()
                    .stroke(appState.currentPalette.primary.opacity(0.46), lineWidth: 2)
                    .frame(width: 104, height: 104)

                Image(systemName: "cpu.fill")
                    .font(.system(size: 42, weight: .black))
                    .foregroundStyle(appState.currentPalette.primary)
            }

            Text("TOOL CORE ONLINE")
                .font(.system(size: 22, weight: .black, design: .monospaced))
                .foregroundStyle(textColor)

            Text("사용 가능한 모듈을 스캔하고 있어.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(themedPanelBackground(cornerRadius: 28))
        .overlay(themedBorder(cornerRadius: 28))
    }

    private var jarvisToolStats: some View {
        HStack(spacing: 10) {
            metricCell(title: "ONLINE", value: "2")
            metricCell(title: "WAITING", value: "3")
            metricCell(title: "MODE", value: "AI")
        }
    }

    // MARK: - iOS

    private var iosToolsInterface: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Tools")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Text("필요한 기능을 위젯처럼 빠르게 열 수 있어.")
                    .font(.subheadline)
                    .foregroundStyle(subTextColor)
            }

            HStack(spacing: 12) {
                iosSummaryWidget(title: "연결됨", value: "2", icon: "checkmark.circle.fill", tint: .green)
                iosSummaryWidget(title: "준비 중", value: "3", icon: "clock.fill", tint: .orange)
            }

            styleStatusCard
            toolsSection(title: "도구 목록", variant: .ios)
            sprintGoalSection
        }
    }

    private func iosSummaryWidget(title: String, value: String, icon: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(tint)

            Spacer(minLength: 8)

            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(textColor)

            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 8)
    }

    // MARK: - Game

    private var gameToolsInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            gameToolHeader
            gameInventoryStats
            styleStatusCard
            toolsSection(title: "ITEM INVENTORY", variant: .game)
            sprintGoalSection
        }
    }

    private var gameToolHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                    .frame(width: 76, height: 76)

                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("INVENTORY")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(textColor)

                Text("기능 아이템을 장착하고 앱을 강화해봐.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(themedPanelBackground(cornerRadius: 26))
        .overlay(themedBorder(cornerRadius: 26))
    }

    private var gameInventoryStats: some View {
        HStack(spacing: 10) {
            metricCell(title: "ITEM", value: "\(tools.count)")
            metricCell(title: "EQUIP", value: "2")
            metricCell(title: "LOCK", value: "3")
        }
    }

    // MARK: - Manduk Mix

    private var mandukToolsInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            mandukToolHeader
            styleStatusCard
            toolsSection(title: "만덕이 추천 도구", variant: .manduk)
            sprintGoalSection
        }
    }

    private var mandukToolHeader: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                .frame(width: 78, height: 78)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text("만덕 도구실")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(textColor)

                Text("필요한 기능을 하나씩 연결해서 너만의 AI 앱으로 키워가자.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(themedPanelBackground(cornerRadius: 28))
        .overlay(themedBorder(cornerRadius: 28))
    }

    // MARK: - CMD

    private var cmdToolsInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            cmdToolHeader
            toolsSection(title: "COMMAND LIST", variant: .cmd)
            sprintGoalSection
        }
    }

    private var cmdToolHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Circle().fill(Color.red.opacity(0.75)).frame(width: 10, height: 10)
                Circle().fill(Color.orange.opacity(0.80)).frame(width: 10, height: 10)
                Circle().fill(Color.green.opacity(0.85)).frame(width: 10, height: 10)
                Spacer()
                Text("tools.exe")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(subTextColor)
            }

            Text("> list --tools")
                .font(.system(size: 24, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)

            Text("2 connected / 3 pending / status: ready")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(subTextColor)
        }
        .padding(18)
        .background(themedPanelBackground(cornerRadius: 24))
        .overlay(themedBorder(cornerRadius: 24))
    }

    // MARK: - Dev

    private var devToolsInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            devToolHeader
            devFilePanel
            toolsSection(title: "ToolKit.swift", variant: .dev)
            sprintGoalSection
        }
    }

    private var devToolHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle().fill(Color.red.opacity(0.78)).frame(width: 10, height: 10)
                Circle().fill(Color.yellow.opacity(0.78)).frame(width: 10, height: 10)
                Circle().fill(Color.green.opacity(0.78)).frame(width: 10, height: 10)

                Text("ToolsView.swift")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(subTextColor)

                Spacer()

                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundStyle(appState.currentPalette.primary)
            }

            Text("ToolKit")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundStyle(textColor)

            Text("let connectedTools = 2\nlet pendingTools = 3")
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(subTextColor)
                .lineSpacing(4)
        }
        .padding(18)
        .background(themedPanelBackground(cornerRadius: 24))
        .overlay(themedBorder(cornerRadius: 24))
    }

    private var devFilePanel: some View {
        HStack(spacing: 12) {
            VStack(spacing: 12) {
                Image(systemName: "hammer.fill")
                Image(systemName: "camera.viewfinder")
                Image(systemName: "note.text")
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(appState.currentPalette.primary)
            .padding(12)
            .background(Color.black.opacity(0.24))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                Text("struct ToolKit {")
                    .foregroundStyle(appState.currentPalette.secondary)
                Text("    var camera = \"connected\"")
                Text("    var memo = \"connected\"")
                Text("    var code = \"pending\"")
                Text("}")
                    .foregroundStyle(appState.currentPalette.secondary)
            }
            .font(.system(size: 12, weight: .semibold, design: .monospaced))
            .foregroundStyle(textColor)

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(themedPanelBackground(cornerRadius: 22))
        .overlay(themedBorder(cornerRadius: 22))
    }

    // MARK: - Shared Sections

    private var styleStatusCard: some View {
        let palette = appState.currentPalette

        return GlassCardView {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                        .frame(width: 58, height: 58)
                        .shadow(color: palette.primary.opacity(0.35), radius: 15, x: 0, y: 8)

                    Image(systemName: appState.selectedStyle.systemImage)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("현재 도구실 UI")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(palette.primary)

                    Text(appState.selectedStyle.title)
                        .font(.headline)
                        .foregroundStyle(textColor)

                    Text("홈과 같은 스타일로 도구실 인터페이스가 바뀌었어.")
                        .font(.caption)
                        .foregroundStyle(subTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
        }
    }

    private func toolsSection(title: String, variant: ToolCardVariant) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle(title, variant: variant)

            VStack(spacing: 12) {
                ForEach(tools) { tool in
                    toolButton(for: tool, variant: variant)
                }
            }
        }
    }

    @ViewBuilder
    private func toolButton(for tool: MandukToolItem, variant: ToolCardVariant) -> some View {
        if tool.title == "AI 카메라" {
            NavigationLink {
                AICameraView()
                    .environmentObject(appState)
            } label: {
                toolCard(for: tool, variant: variant)
            }
            .buttonStyle(.plain)
        } else if tool.title == "빠른 메모" {
            NavigationLink {
                QuickMemoView()
                    .environmentObject(appState)
            } label: {
                toolCard(for: tool, variant: variant)
            }
            .buttonStyle(.plain)
        } else {
            Button {
                appState.showToast(
                    title: "아직 준비 중이야",
                    message: "\(tool.title)은 다음 스프린트에서 기능을 연결할게.",
                    type: .info
                )
            } label: {
                toolCard(for: tool, variant: variant)
            }
            .buttonStyle(.plain)
        }
    }

    private var sprintGoalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Sprint 1C 진행 상황", variant: .normal)

            GlassCardView {
                VStack(alignment: .leading, spacing: 10) {
                    SprintGoalRow(text: "기본 화면 구조 만들기", isDone: true)
                    SprintGoalRow(text: "빠른 메모 기능 연결", isDone: true)
                    SprintGoalRow(text: "AI 카메라 임시 분석 연결", isDone: true)
                    SprintGoalRow(text: "UI 스타일 A/B/C/D/E/F/G 적용", isDone: true)
                    SprintGoalRow(text: "코드 저장소 연결", isDone: false)
                }
            }
        }
    }

    private func toolCard(for tool: MandukToolItem, variant: ToolCardVariant) -> some View {
        let palette = appState.currentPalette
        let tint = resolvedTint(for: tool)
        let isConnected = tool.status == "연결됨"

        return HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: iconCornerRadius(for: variant), style: .continuous)
                    .fill(iconBackground(tint: tint, variant: variant))
                    .frame(width: 58, height: 58)
                    .overlay(
                        RoundedRectangle(cornerRadius: iconCornerRadius(for: variant), style: .continuous)
                            .stroke(tint.opacity(borderOpacity(for: variant)), lineWidth: 1)
                    )

                Image(systemName: tool.systemImage)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(tint)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(cardTitle(for: tool, variant: variant))
                    .font(cardTitleFont(for: variant))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Text(cardSubtitle(for: tool, variant: variant))
                    .font(cardSubtitleFont(for: variant))
                    .foregroundStyle(subTextColor)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 8)

            Text(statusText(for: tool, variant: variant))
                .font(statusFont(for: variant))
                .foregroundStyle(isConnected ? tint : subTextColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background((isConnected ? tint : Color.secondary).opacity(statusOpacity(for: variant)))
                .clipShape(Capsule())

            Image(systemName: variant == .cmd ? "terminal" : "chevron.right")
                .font(.footnote.weight(.bold))
                .foregroundStyle(subTextColor)
        }
        .padding(cardPadding(for: variant))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground(for: variant))
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius(for: variant), style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cardCornerRadius(for: variant), style: .continuous)
                .stroke(palette.cardStroke, lineWidth: strokeWidth(for: variant))
        )
        .shadow(
            color: shadowColor,
            radius: appState.selectedStyle == .ios ? 8 : 14,
            x: 0,
            y: appState.selectedStyle == .ios ? 4 : 8
        )
    }

    private func metricCell(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(appState.currentPalette.primary)

            Text(title)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(themedPanelBackground(cornerRadius: 20))
        .overlay(themedBorder(cornerRadius: 20))
    }

    private func resolvedTint(for tool: MandukToolItem) -> Color {
        switch appState.selectedStyle {
        case .basic:
            return tool.tint
        case .jarvis:
            return appState.currentPalette.primary
        case .ios:
            return tool.tint
        case .game:
            return tool.title == "빠른 메모" ? appState.currentPalette.accent : appState.currentPalette.secondary
        case .mandukMix:
            return tool.title == "AI 카메라" ? appState.currentPalette.primary : tool.tint
        case .cmd:
            return appState.currentPalette.primary
        case .dev:
            return tool.title == "코드 저장소" ? appState.currentPalette.secondary : appState.currentPalette.primary
        }
    }

    private func sectionTitle(_ title: String, variant: ToolCardVariant) -> some View {
        Text(title)
            .font(variant == .cmd || variant == .dev ? .system(size: 14, weight: .black, design: .monospaced) : .headline.weight(.bold))
            .foregroundStyle(variant == .cmd || variant == .dev || variant == .jarvis || variant == .game ? appState.currentPalette.primary : textColor)
    }

    private var textColor: Color {
        appState.currentPalette.textPrimary
    }

    private var subTextColor: Color {
        appState.currentPalette.textSecondary
    }

    private func cardTitle(for tool: MandukToolItem, variant: ToolCardVariant) -> String {
        switch variant {
        case .cmd:
            return "run \(commandName(for: tool))"
        case .dev:
            return "\(functionName(for: tool))()"
        case .game:
            return "ITEM · \(tool.title)"
        default:
            return tool.title
        }
    }

    private func cardSubtitle(for tool: MandukToolItem, variant: ToolCardVariant) -> String {
        switch variant {
        case .cmd:
            return "module: \(tool.subtitle)"
        case .dev:
            return "// \(tool.subtitle)"
        case .game:
            return "효과: \(tool.subtitle)"
        default:
            return tool.subtitle
        }
    }

    private func statusText(for tool: MandukToolItem, variant: ToolCardVariant) -> String {
        switch variant {
        case .cmd:
            return tool.status == "연결됨" ? "ONLINE" : "WAIT"
        case .dev:
            return tool.status == "연결됨" ? "true" : "false"
        case .game:
            return tool.status == "연결됨" ? "EQUIP" : "LOCK"
        default:
            return tool.status
        }
    }

    private func commandName(for tool: MandukToolItem) -> String {
        switch tool.title {
        case "AI 카메라": return "camera.scan"
        case "코드 저장소": return "code.repo"
        case "쇼츠 메이커": return "shorts.make"
        case "원격 제어": return "remote.link"
        case "빠른 메모": return "memo.quick"
        default: return "tool.open"
        }
    }

    private func functionName(for tool: MandukToolItem) -> String {
        switch tool.title {
        case "AI 카메라": return "scanImage"
        case "코드 저장소": return "openCodeRepo"
        case "쇼츠 메이커": return "makeShorts"
        case "원격 제어": return "connectRemote"
        case "빠른 메모": return "quickMemo"
        default: return "openTool"
        }
    }

    private func cardTitleFont(for variant: ToolCardVariant) -> Font {
        switch variant {
        case .cmd, .dev:
            return .system(size: 14, weight: .black, design: .monospaced)
        default:
            return .headline
        }
    }

    private func cardSubtitleFont(for variant: ToolCardVariant) -> Font {
        switch variant {
        case .cmd, .dev:
            return .system(size: 11, weight: .semibold, design: .monospaced)
        default:
            return .subheadline
        }
    }

    private func statusFont(for variant: ToolCardVariant) -> Font {
        switch variant {
        case .cmd, .dev, .game:
            return .system(size: 10, weight: .black, design: .monospaced)
        default:
            return .caption2.weight(.semibold)
        }
    }

    private func cardPadding(for variant: ToolCardVariant) -> CGFloat {
        switch variant {
        case .ios:
            return 16
        case .cmd, .dev:
            return 14
        default:
            return 16
        }
    }

    private func cardCornerRadius(for variant: ToolCardVariant) -> CGFloat {
        switch variant {
        case .cmd:
            return 16
        case .ios:
            return 26
        default:
            return 24
        }
    }

    private func iconCornerRadius(for variant: ToolCardVariant) -> CGFloat {
        switch variant {
        case .cmd:
            return 10
        case .game:
            return 18
        default:
            return 18
        }
    }

    private func borderOpacity(for variant: ToolCardVariant) -> Double {
        switch variant {
        case .cmd, .dev:
            return 0.36
        case .ios:
            return 0.14
        default:
            return 0.30
        }
    }

    private func statusOpacity(for variant: ToolCardVariant) -> Double {
        switch variant {
        case .cmd, .dev:
            return 0.18
        case .ios:
            return 0.10
        default:
            return 0.16
        }
    }

    private func strokeWidth(for variant: ToolCardVariant) -> CGFloat {
        switch variant {
        case .game, .cmd, .dev:
            return 1.3
        default:
            return 1
        }
    }

    private func iconBackground(tint: Color, variant: ToolCardVariant) -> LinearGradient {
        LinearGradient(
            colors: [
                tint.opacity(variant == .ios ? 0.13 : 0.26),
                appState.currentPalette.cardHighlight.opacity(variant == .ios ? 0.75 : 0.22),
                tint.opacity(variant == .game ? 0.22 : 0.10)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func cardBackground(for variant: ToolCardVariant) -> some View {
        let palette = appState.currentPalette

        return RoundedRectangle(cornerRadius: cardCornerRadius(for: variant), style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        variant == .cmd ? Color.black.opacity(0.38) : palette.cardHighlight.opacity(variant == .ios ? 0.92 : 0.38),
                        palette.cardBackground.opacity(variant == .ios ? 0.86 : 0.72),
                        variant == .dev ? palette.secondary.opacity(0.10) : palette.primary.opacity(variant == .ios ? 0.04 : 0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func themedPanelBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.selectedStyle == .cmd ? Color.black.opacity(0.42) : appState.currentPalette.cardHighlight.opacity(0.52),
                        appState.currentPalette.cardBackground,
                        appState.currentPalette.primary.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func themedBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.cardStroke, lineWidth: 1.2)
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

private enum ToolCardVariant {
    case normal
    case jarvis
    case ios
    case game
    case manduk
    case cmd
    case dev
}

private struct MandukToolItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
    let status: String
    let tint: Color
}

private struct SprintGoalRow: View {
    @EnvironmentObject private var appState: AppState

    let text: String
    let isDone: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isDone ? .green : appState.currentPalette.textSecondary)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(isDone ? appState.currentPalette.textPrimary : appState.currentPalette.textSecondary)

            Spacer()
        }
    }
}

#Preview {
    ToolsView()
        .environmentObject(AppState())
}
