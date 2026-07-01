import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isShowingQuickMemoEditor = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView(showsIndicators: false) {
                    Group {
                        switch appState.selectedStyle {
                        case .basic:
                            normalHomeInterface
                        case .jarvis:
                            jarvisHomeInterface
                        case .ios:
                            iosHomeInterface
                        case .game:
                            gameHomeInterface
                        case .mandukMix:
                            mandukMixHomeInterface
                        case .cmd:
                            cmdHomeInterface
                        case .dev:
                            devHomeInterface
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 80)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $isShowingQuickMemoEditor) {
                QuickMemoEditorView()
                    .environmentObject(appState)
            }
        }
    }

    private var navigationTitle: String {
        switch appState.selectedStyle {
        case .basic:
            return "MandukAI"
        case .jarvis:
            return "AI Core"
        case .ios:
            return "Today"
        case .game:
            return "Quest Hub"
        case .mandukMix:
            return "Manduk Hub"
        case .cmd:
            return "Terminal"
        case .dev:
            return "Dev Studio"
        }
    }

    // MARK: - Normal Interface

    private var normalHomeInterface: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            styleHeroCard
            statusCard
            quickActionsSection
            recentMemosSection
            projectsSection
        }
    }

    // MARK: - Jarvis Interface

    private var jarvisHomeInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            jarvisCoreHeader
            jarvisStatusGrid
            styleHeroCard
            jarvisCommandCenter
            jarvisMissionPanel
        }
    }

    private var jarvisCoreHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(appState.currentPalette.primary.opacity(0.16), lineWidth: 18)
                    .frame(width: 150, height: 150)

                Circle()
                    .stroke(appState.currentPalette.primary.opacity(0.44), lineWidth: 2)
                    .frame(width: 124, height: 124)

                Circle()
                    .stroke(appState.currentPalette.secondary.opacity(0.35), lineWidth: 1)
                    .frame(width: 94, height: 94)

                VStack(spacing: 4) {
                    Text("AI")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(appState.currentPalette.primary)

                    Text("CORE")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(subTextColor)
                }
            }

            VStack(spacing: 6) {
                Text("SYSTEM ONLINE")
                    .font(.system(size: 22, weight: .black, design: .monospaced))
                    .foregroundStyle(cardTextColor)

                Text("\(appState.userName)의 AI 작업실이 준비됐어")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .background(jarvisPanelBackground(cornerRadius: 28))
        .overlay(jarvisBorder(cornerRadius: 28))
    }

    private var jarvisStatusGrid: some View {
        HStack(spacing: 10) {
            jarvisStatusCell(title: "PROJECT", value: "\(appState.projects.count)", icon: "folder.fill")
            jarvisStatusCell(title: "MEMO", value: "\(appState.quickMemos.count)", icon: "note.text")
            jarvisStatusCell(title: "MODE", value: "AI", icon: "cpu.fill")
        }
    }

    private func jarvisStatusCell(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(appState.currentPalette.primary)

            Text(value)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(cardTextColor)

            Text(title)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(jarvisPanelBackground(cornerRadius: 20))
        .overlay(jarvisBorder(cornerRadius: 20))
    }

    private var jarvisCommandCenter: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("COMMAND CENTER")
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                jarvisActionButton(title: "AI CHAT", icon: "bubble.left.and.bubble.right.fill") { appState.switchTab(.chat) }
                jarvisActionButton(title: "PROJECTS", icon: "folder.fill") { appState.switchTab(.projects) }
                jarvisActionButton(title: "NEW MEMO", icon: "note.text.badge.plus") { isShowingQuickMemoEditor = true }
                jarvisActionButton(title: "TOOLS", icon: "wand.and.stars") { appState.switchTab(.tools) }
            }
        }
        .padding(16)
        .background(jarvisPanelBackground(cornerRadius: 22))
        .overlay(jarvisBorder(cornerRadius: 22))
    }

    private func jarvisActionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(appState.currentPalette.primary)
                    .frame(width: 36, height: 36)
                    .background(appState.currentPalette.primary.opacity(0.16))
                    .clipShape(Circle())

                Text(title)
                    .font(.system(size: 12, weight: .black, design: .monospaced))
                    .foregroundStyle(cardTextColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color.black.opacity(0.18))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var jarvisMissionPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ACTIVE MISSION")
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)

            if let project = appState.projects.first {
                Text(project.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)

                ProgressView(value: project.progress, total: 100)
                    .tint(appState.currentPalette.primary)

                Text("AI 분석 진행률 \(Int(project.progress))%")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
            } else {
                Text("새 프로젝트를 시작하면 AI 미션이 표시돼.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
            }
        }
        .padding(16)
        .background(jarvisPanelBackground(cornerRadius: 22))
        .overlay(jarvisBorder(cornerRadius: 22))
    }

    private func jarvisPanelBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.currentPalette.primary.opacity(0.14),
                        Color.black.opacity(0.22),
                        appState.currentPalette.cardBackground
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func jarvisBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.primary.opacity(0.28), lineWidth: 1.2)
    }

    // MARK: - iOS Interface

    private var iosHomeInterface: some View {
        VStack(alignment: .leading, spacing: 18) {
            iosTodayHeader
            iosWidgetGrid
            styleHeroCard
            iosLargeMemoWidget
            iosProjectWidget
        }
    }

    private var iosTodayHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Today")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(cardTextColor)

            Text("안녕, \(appState.userName). 오늘의 작업을 정리했어.")
                .font(.subheadline)
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var iosWidgetGrid: some View {
        HStack(spacing: 12) {
            iosWidget(title: "프로젝트", value: "\(appState.projects.count)", icon: "folder.fill", tint: .blue) { appState.switchTab(.projects) }
            iosWidget(title: "메모", value: "\(appState.quickMemos.count)", icon: "note.text", tint: .green) { isShowingQuickMemoEditor = true }
        }
    }

    private func iosWidget(title: String, value: String, icon: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(tint)

                Spacer(minLength: 8)

                Text(value)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(cardTextColor)

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
        .buttonStyle(.plain)
    }

    private var iosLargeMemoWidget: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("빠른 메모", systemImage: "note.text.badge.plus")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(cardTextColor)

                Spacer()

                Button("추가") { isShowingQuickMemoEditor = true }
                    .font(.caption.weight(.bold))
            }

            if let memo = appState.quickMemos.first {
                Text(memo.title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)

                Text(memo.previewText)
                    .font(.subheadline)
                    .foregroundStyle(subTextColor)
                    .lineLimit(2)
            } else {
                Text("오늘 떠오른 아이디어를 바로 기록해봐.")
                    .font(.subheadline)
                    .foregroundStyle(subTextColor)
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 8)
    }

    private var iosProjectWidget: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("진행 중", systemImage: "checklist")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(cardTextColor)

                Spacer()

                Button("보기") { appState.switchTab(.projects) }
                    .font(.caption.weight(.bold))
            }

            if let project = appState.projects.first {
                Text(project.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)

                ProgressView(value: project.progress, total: 100)
                    .tint(appState.currentPalette.primary)
            } else {
                Text("프로젝트를 추가하면 여기 표시돼.")
                    .font(.subheadline)
                    .foregroundStyle(subTextColor)
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 8)
    }

    // MARK: - Game Interface

    private var gameHomeInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            gameProfileCard
            gameStatsPanel
            styleHeroCard
            gameQuestPanel
            gameRewardPanel
        }
    }

    private var gameProfileCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                    .frame(width: 76, height: 76)
                    .shadow(color: appState.currentPalette.primary.opacity(0.35), radius: 18, x: 0, y: 8)

                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("PLAYER \(appState.userName)")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(cardTextColor)

                Text("LV. 7  ·  APP BUILDER")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.accent)

                ProgressView(value: Double(appState.projects.count + appState.quickMemos.count), total: 20)
                    .tint(appState.currentPalette.accent)
            }

            Spacer()
        }
        .padding(18)
        .background(gamePanelBackground(cornerRadius: 26))
        .overlay(gameBorder(cornerRadius: 26))
    }

    private var gameStatsPanel: some View {
        HStack(spacing: 10) {
            gameStat(title: "QUEST", value: "\(appState.projects.count)")
            gameStat(title: "ITEM", value: "\(appState.quickMemos.count)")
            gameStat(title: "MODE", value: "D")
        }
    }

    private func gameStat(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(appState.currentPalette.accent)

            Text(title)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(gamePanelBackground(cornerRadius: 20))
        .overlay(gameBorder(cornerRadius: 20))
    }

    private var gameQuestPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DAILY QUEST")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(appState.currentPalette.accent)

            gameQuestRow(title: "AI 채팅으로 아이디어 정리", icon: "bubble.left.fill") { appState.switchTab(.chat) }
            gameQuestRow(title: "새 메모 아이템 획득", icon: "note.text.badge.plus") { isShowingQuickMemoEditor = true }
            gameQuestRow(title: "프로젝트 진행률 확인", icon: "flag.checkered") { appState.switchTab(.projects) }
        }
        .padding(16)
        .background(gamePanelBackground(cornerRadius: 22))
        .overlay(gameBorder(cornerRadius: 22))
    }

    private func gameQuestRow(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .black))
                    .foregroundStyle(appState.currentPalette.accent)
                    .frame(width: 34, height: 34)
                    .background(appState.currentPalette.accent.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(cardTextColor)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.black))
                    .foregroundStyle(subTextColor)
            }
            .padding(12)
            .background(Color.black.opacity(0.16))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var gameRewardPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("REWARD BOX")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(appState.currentPalette.accent)

            if let project = appState.projects.first {
                Text(project.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)

                Text("완료하면 다음 기능 해금")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)

                ProgressView(value: project.progress, total: 100)
                    .tint(appState.currentPalette.accent)
            } else {
                Text("새 퀘스트를 시작해줘.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
            }
        }
        .padding(16)
        .background(gamePanelBackground(cornerRadius: 22))
        .overlay(gameBorder(cornerRadius: 22))
    }

    private func gamePanelBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.currentPalette.cardHighlight.opacity(0.70),
                        appState.currentPalette.cardBackground,
                        appState.currentPalette.secondary.opacity(0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func gameBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.accent.opacity(0.30), lineWidth: 1.3)
    }

    // MARK: - Manduk Mix Interface

    private var mandukMixHomeInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            mandukAssistantCard
            mandukDashboardGrid
            styleHeroCard
            mandukShortcutPanel
            mandukFocusPanel
        }
    }

    private var mandukAssistantCard: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                    .frame(width: 78, height: 78)
                    .shadow(color: appState.currentPalette.primary.opacity(0.34), radius: 18, x: 0, y: 8)

                Image(systemName: "sparkles")
                    .font(.system(size: 34, weight: .black))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("만덕 AI")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(cardTextColor)

                Text("앱 개발, 메모, 프로젝트를 한 곳에서 관리해줄게.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(mandukPanelBackground(cornerRadius: 28))
        .overlay(mandukBorder(cornerRadius: 28))
    }

    private var mandukDashboardGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            mandukDashboardCard(title: "AI 채팅", subtitle: "바로 질문", icon: "bubble.left.and.bubble.right.fill") { appState.switchTab(.chat) }
            mandukDashboardCard(title: "빠른 메모", subtitle: "아이디어 저장", icon: "note.text.badge.plus") { isShowingQuickMemoEditor = true }
            mandukDashboardCard(title: "프로젝트", subtitle: "진행률 확인", icon: "folder.fill") { appState.switchTab(.projects) }
            mandukDashboardCard(title: "도구실", subtitle: "기능 모음", icon: "square.grid.2x2.fill") { appState.switchTab(.tools) }
        }
    }

    private func mandukDashboardCard(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(appState.currentPalette.primary)
                    .frame(width: 40, height: 40)
                    .background(appState.currentPalette.primary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(cardTextColor)

                Text(subtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
            .background(mandukPanelBackground(cornerRadius: 22))
            .overlay(mandukBorder(cornerRadius: 22))
        }
        .buttonStyle(.plain)
    }

    private var mandukShortcutPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("오늘의 추천")
                .font(.headline.weight(.bold))
                .foregroundStyle(cardTextColor)

            Text("새 아이디어가 떠오르면 빠른 메모에 저장하고, 프로젝트로 옮겨서 개발 루틴을 만들어보자.")
                .font(.subheadline)
                .foregroundStyle(subTextColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(mandukPanelBackground(cornerRadius: 24))
        .overlay(mandukBorder(cornerRadius: 24))
    }

    private var mandukFocusPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("FOCUS")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.primary)

                Spacer()

                Text(appState.selectedStyle.shortTitle)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(subTextColor)
            }

            if let project = appState.projects.first {
                Text(project.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)

                ProgressView(value: project.progress, total: 100)
                    .tint(appState.currentPalette.primary)
            } else {
                Text("진행 중인 프로젝트가 없어.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
            }
        }
        .padding(16)
        .background(mandukPanelBackground(cornerRadius: 22))
        .overlay(mandukBorder(cornerRadius: 22))
    }

    private func mandukPanelBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.currentPalette.cardHighlight.opacity(0.50),
                        appState.currentPalette.cardBackground,
                        appState.currentPalette.primary.opacity(0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func mandukBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.cardStroke, lineWidth: 1.2)
    }

    // MARK: - CMD Interface

    private var cmdHomeInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            cmdTerminalHeader
            cmdSystemPanel
            styleHeroCard
            cmdCommandPanel
            cmdLogPanel
            cmdProjectPanel
        }
    }

    private var cmdTerminalHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Circle().fill(Color.red.opacity(0.75)).frame(width: 10, height: 10)
                Circle().fill(Color.orange.opacity(0.80)).frame(width: 10, height: 10)
                Circle().fill(Color.green.opacity(0.85)).frame(width: 10, height: 10)

                Spacer()

                Text("mandukai@terminal")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.textSecondary)
            }

            Text(">_ MANDUK_AI_BOOT")
                .font(.system(size: 24, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)

            Text("user: \(appState.userName)  |  mode: CMD  |  status: ONLINE")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(appState.currentPalette.textSecondary)
        }
        .padding(18)
        .background(cmdWindowBackground(cornerRadius: 24))
        .overlay(cmdBorder(cornerRadius: 24))
    }

    private var cmdSystemPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            cmdLine("run system.status")

            HStack(spacing: 10) {
                cmdMetric(title: "PROJECTS", value: "\(appState.projects.count)")
                cmdMetric(title: "MEMOS", value: "\(appState.quickMemos.count)")
                cmdMetric(title: "THEME", value: "CMD")
            }
        }
        .padding(16)
        .background(cmdWindowBackground(cornerRadius: 22))
        .overlay(cmdBorder(cornerRadius: 22))
    }

    private var cmdCommandPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("COMMANDS")
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 10
            ) {
                cmdCommandButton(command: "open.chat", subtitle: "AI 채팅") {
                    appState.switchTab(.chat)
                }

                cmdCommandButton(command: "open.projects", subtitle: "프로젝트") {
                    appState.switchTab(.projects)
                }

                cmdCommandButton(command: "new.memo", subtitle: "메모 추가") {
                    isShowingQuickMemoEditor = true
                }

                cmdCommandButton(command: "open.settings", subtitle: "설정") {
                    appState.switchTab(.settings)
                }
            }
        }
        .padding(16)
        .background(cmdWindowBackground(cornerRadius: 22))
        .overlay(cmdBorder(cornerRadius: 22))
    }

    private var cmdLogPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SYSTEM LOG")
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)

            if appState.quickMemos.isEmpty {
                cmdLogRow("memo.cache.empty")
                cmdLogRow("try command: new.memo")
            } else {
                ForEach(Array(appState.quickMemos.prefix(3).enumerated()), id: \.element.id) { index, memo in
                    cmdLogRow("memo[\(index)] \(memo.title)")
                }
            }
        }
        .padding(16)
        .background(cmdWindowBackground(cornerRadius: 22))
        .overlay(cmdBorder(cornerRadius: 22))
    }

    private var cmdProjectPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("PROJECT_PROCESS")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.primary)

                Spacer()

                Button("view.all") {
                    appState.switchTab(.projects)
                }
                .font(.system(size: 11, weight: .bold, design: .monospaced))
            }

            if let project = appState.projects.first {
                Text(project.title)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)

                ProgressView(value: project.progress, total: 100)
                    .tint(appState.currentPalette.primary)

                Text("progress: \(Int(project.progress))%")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(subTextColor)
            } else {
                cmdLogRow("no active project")
            }
        }
        .padding(16)
        .background(cmdWindowBackground(cornerRadius: 22))
        .overlay(cmdBorder(cornerRadius: 22))
    }

    private func cmdLine(_ text: String) -> some View {
        HStack(spacing: 8) {
            Text(">")
                .foregroundStyle(appState.currentPalette.primary)
            Text(text)
                .foregroundStyle(appState.currentPalette.textPrimary)
            Spacer(minLength: 0)
        }
        .font(.system(size: 13, weight: .bold, design: .monospaced))
    }

    private func cmdMetric(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(appState.currentPalette.textSecondary)

            Text(value)
                .font(.system(size: 20, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.black.opacity(0.26))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(appState.currentPalette.primary.opacity(0.24), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func cmdCommandButton(command: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text("> \(command)")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text(subtitle)
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color.black.opacity(0.28))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(appState.currentPalette.primary.opacity(0.28), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func cmdLogRow(_ text: String) -> some View {
        HStack(spacing: 8) {
            Text("[")
                .foregroundStyle(appState.currentPalette.primary.opacity(0.7))
            Text("OK")
                .foregroundStyle(appState.currentPalette.primary)
            Text("]")
                .foregroundStyle(appState.currentPalette.primary.opacity(0.7))
            Text(text)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Spacer(minLength: 0)
        }
        .font(.system(size: 12, weight: .semibold, design: .monospaced))
        .foregroundStyle(appState.currentPalette.textSecondary)
    }

    private func cmdWindowBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.42),
                        appState.currentPalette.cardBackground,
                        appState.currentPalette.primary.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func cmdBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.primary.opacity(0.34), lineWidth: 1.2)
    }

    // MARK: - Dev Interface

    private var devHomeInterface: some View {
        VStack(alignment: .leading, spacing: 16) {
            devEditorHeader
            devWorkspacePanel
            styleHeroCard
            devActionsPanel
            devCodeMemoPanel
            devBuildPanel
        }
    }

    private var devEditorHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle().fill(Color.red.opacity(0.78)).frame(width: 10, height: 10)
                Circle().fill(Color.yellow.opacity(0.78)).frame(width: 10, height: 10)
                Circle().fill(Color.green.opacity(0.78)).frame(width: 10, height: 10)

                Text("HomeView.swift")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.textSecondary)

                Spacer()

                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundStyle(appState.currentPalette.primary)
            }

            Text("Dev Studio")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(cardTextColor)

            Text("let user = \"\(appState.userName)\"\nlet mission = \"오늘도 앱 개발하기\"")
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(appState.currentPalette.textSecondary)
                .lineSpacing(4)
        }
        .padding(18)
        .background(devEditorBackground(cornerRadius: 24))
        .overlay(devBorder(cornerRadius: 24))
    }

    private var devWorkspacePanel: some View {
        HStack(spacing: 12) {
            devFileRail

            VStack(alignment: .leading, spacing: 12) {
                Text("struct Dashboard: View {")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.secondary)

                devCodeLine(key: "projects", value: "\(appState.projects.count)")
                devCodeLine(key: "memos", value: "\(appState.quickMemos.count)")
                devCodeLine(key: "theme", value: "Dev")

                Text("}")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color.black.opacity(0.22))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .padding(16)
        .background(devEditorBackground(cornerRadius: 22))
        .overlay(devBorder(cornerRadius: 22))
    }

    private var devFileRail: some View {
        VStack(spacing: 12) {
            devRailIcon("house.fill", isActive: true)
            devRailIcon("bubble.left.fill", isActive: false)
            devRailIcon("folder.fill", isActive: false)
            devRailIcon("gearshape.fill", isActive: false)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 10)
        .background(Color.black.opacity(0.26))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func devRailIcon(_ systemImage: String, isActive: Bool) -> some View {
        Image(systemName: systemImage)
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(isActive ? appState.currentPalette.primary : appState.currentPalette.textTertiary)
            .frame(width: 28, height: 28)
            .background(isActive ? appState.currentPalette.primary.opacity(0.14) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func devCodeLine(key: String, value: String) -> some View {
        HStack(spacing: 6) {
            Text("    var")
                .foregroundStyle(appState.currentPalette.primary)
            Text(key)
                .foregroundStyle(cardTextColor)
            Text("=")
                .foregroundStyle(appState.currentPalette.textTertiary)
            Text("\"\(value)\"")
                .foregroundStyle(appState.currentPalette.accent)
            Spacer(minLength: 0)
        }
        .font(.system(size: 13, weight: .semibold, design: .monospaced))
    }

    private var devActionsPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Functions")
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(cardTextColor)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 10
            ) {
                devFunctionButton(name: "askAI()", icon: "bubble.left.and.bubble.right.fill") {
                    appState.switchTab(.chat)
                }

                devFunctionButton(name: "projects()", icon: "folder.fill") {
                    appState.switchTab(.projects)
                }

                devFunctionButton(name: "newMemo()", icon: "note.text.badge.plus") {
                    isShowingQuickMemoEditor = true
                }

                devFunctionButton(name: "settings()", icon: "paintpalette.fill") {
                    appState.switchTab(.settings)
                }
            }
        }
        .padding(16)
        .background(devEditorBackground(cornerRadius: 22))
        .overlay(devBorder(cornerRadius: 22))
    }

    private func devFunctionButton(name: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(appState.currentPalette.primary)
                    .frame(width: 32, height: 32)
                    .background(appState.currentPalette.primary.opacity(0.13))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                Text(name)
                    .font(.system(size: 12, weight: .black, design: .monospaced))
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Spacer(minLength: 0)
            }
            .padding(12)
            .background(Color.black.opacity(0.20))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(appState.currentPalette.primary.opacity(0.18), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var devCodeMemoPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("RecentMemo.swift")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.primary)

                Spacer()

                Button("add") {
                    isShowingQuickMemoEditor = true
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
            }

            if appState.quickMemos.isEmpty {
                devCodeComment("// 아직 메모가 없어")
                devCodeComment("// newMemo()로 추가해줘")
            } else {
                ForEach(appState.quickMemos.prefix(3)) { memo in
                    devMemoRow(memo)
                }
            }
        }
        .padding(16)
        .background(devEditorBackground(cornerRadius: 22))
        .overlay(devBorder(cornerRadius: 22))
    }

    private func devMemoRow(_ memo: QuickMemo) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("let \(memo.category.title) = \"\(memo.title)\"")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(cardTextColor)
                .lineLimit(1)

            Text("// \(memo.previewText)")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundStyle(subTextColor)
                .lineLimit(1)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func devCodeComment(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold, design: .monospaced))
            .foregroundStyle(appState.currentPalette.textSecondary)
    }

    private var devBuildPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Build Output")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.primary)

                Spacer()

                Text("SUCCESS")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.14))
                    .clipShape(Capsule())
            }

            if let project = appState.projects.first {
                Text(project.title)
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)

                ProgressView(value: project.progress, total: 100)
                    .tint(appState.currentPalette.primary)

                Text("Compiled \(Int(project.progress))% of current module")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(subTextColor)
            } else {
                devCodeComment("// 프로젝트가 아직 없어")
            }
        }
        .padding(16)
        .background(devEditorBackground(cornerRadius: 22))
        .overlay(devBorder(cornerRadius: 22))
    }

    private func devEditorBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.currentPalette.cardHighlight.opacity(0.74),
                        appState.currentPalette.cardBackground,
                        appState.currentPalette.secondary.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func devBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.cardStroke, lineWidth: 1.2)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("안녕, \(appState.userName)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(headerTextColor)

            Text("오늘도 앱 개발을 이어가보자.")
                .font(.subheadline)
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Style Hero

    private var styleHeroCard: some View {
        let palette = appState.currentPalette

        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                        .frame(width: 64, height: 64)
                        .shadow(color: palette.primary.opacity(0.42), radius: 18, x: 0, y: 8)

                    Image(systemName: appState.selectedStyle.systemImage)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("현재 UI")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(palette.primary)

                    Text(appState.selectedStyle.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(cardTextColor)

                    Text(appState.selectedStyle.description)
                        .font(.caption)
                        .foregroundStyle(subTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            HStack(spacing: 8) {
                styleMiniChip("A", style: .basic)
                styleMiniChip("B", style: .jarvis)
                styleMiniChip("C", style: .ios)
                styleMiniChip("D", style: .game)
                styleMiniChip("E", style: .mandukMix)
                styleMiniChip("F", style: .cmd)
                styleMiniChip("G", style: .dev)
            }
        }
        .padding(18)
        .background(heroBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(palette.cardStroke, lineWidth: 1.3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }

    private func styleMiniChip(_ title: String, style: AppStyle) -> some View {
        let isSelected = appState.selectedStyle == style
        let palette = MandukTheme.palette(for: style)

        return Button {
            appState.updateSelectedStyle(style)
        } label: {
            Text(title)
                .font(.caption.weight(.black))
                .foregroundStyle(isSelected ? .white : palette.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(isSelected ? palette.primary : palette.primary.opacity(0.12))
                )
                .overlay(
                    Capsule()
                        .stroke(palette.primary.opacity(isSelected ? 0.95 : 0.28), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Status Card

    private var statusCard: some View {
        GlassCardView {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    GlassIconView(systemImage: "sparkles")

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sprint 1C")
                            .font(.headline)
                            .foregroundStyle(cardTextColor)

                        Text("빠른 메모와 AI 카메라 작동 중")
                            .font(.caption)
                            .foregroundStyle(subTextColor)
                    }

                    Spacer()
                }

                Divider()
                    .opacity(appState.selectedStyle == .ios ? 0.45 : 0.25)

                HStack(spacing: 12) {
                    statusItem(title: "프로젝트", value: "\(appState.projects.count)개")
                    statusItem(title: "메모", value: "\(appState.quickMemos.count)개")
                    statusItem(title: "UI", value: appState.selectedStyle.shortTitle)
                }
            }
        }
    }

    private func statusItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(subTextColor)

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(cardTextColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Quick Actions

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("빠른 실행")

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                quickActionButton(
                    title: "AI 채팅",
                    subtitle: "바로 질문하기",
                    systemImage: "bubble.left.and.bubble.right.fill",
                    tint: appState.currentPalette.primary
                ) {
                    appState.switchTab(.chat)
                }

                quickActionButton(
                    title: "프로젝트",
                    subtitle: "진행 상황 보기",
                    systemImage: "folder.fill",
                    tint: .orange
                ) {
                    appState.switchTab(.projects)
                }

                quickActionButton(
                    title: "메모 추가",
                    subtitle: "바로 작성",
                    systemImage: "note.text.badge.plus",
                    tint: .green
                ) {
                    isShowingQuickMemoEditor = true
                }

                quickActionButton(
                    title: "설정",
                    subtitle: "UI 변경",
                    systemImage: "paintpalette.fill",
                    tint: appState.currentPalette.accent
                ) {
                    appState.switchTab(.settings)
                }
            }
        }
    }

    private func quickActionButton(
        title: String,
        subtitle: String,
        systemImage: String,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(tint)
                    .frame(width: 40, height: 40)
                    .background(tint.opacity(appState.selectedStyle == .ios ? 0.12 : 0.18))
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .stroke(tint.opacity(appState.selectedStyle == .ios ? 0.10 : 0.26), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(cardTextColor)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(subTextColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(actionCardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Recent Memos

    private var recentMemosSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionTitle("최근 메모")

                Spacer()

                HStack(spacing: 10) {
                    Button("추가") {
                        isShowingQuickMemoEditor = true
                    }

                    Button("전체보기") {
                        appState.switchTab(.tools)
                    }
                }
                .font(.caption)
                .fontWeight(.semibold)
            }

            if appState.quickMemos.isEmpty {
                emptyMemoView
            } else {
                VStack(spacing: 10) {
                    ForEach(appState.quickMemos.prefix(2)) { memo in
                        memoRow(memo)
                    }
                }
            }
        }
    }

    private var emptyMemoView: some View {
        VStack(spacing: 10) {
            Image(systemName: "note.text.badge.plus")
                .font(.largeTitle)
                .foregroundStyle(appState.currentPalette.primary)

            Text("아직 메모가 없어")
                .font(.headline)
                .foregroundStyle(cardTextColor)

            Text("홈에서 바로 빠른 메모를 추가할 수 있어.")
                .font(.caption)
                .foregroundStyle(subTextColor)

            Button {
                isShowingQuickMemoEditor = true
            } label: {
                Label("메모 추가", systemImage: "plus.circle.fill")
                    .font(.caption.weight(.semibold))
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(actionCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func memoRow(_ memo: QuickMemo) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.12 : 0.18))
                    .frame(width: 42, height: 42)

                Image(systemName: memo.category.systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(appState.currentPalette.primary)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(memo.title)
                        .font(.headline)
                        .foregroundStyle(cardTextColor)
                        .lineLimit(1)

                    if memo.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }

                Text(memo.previewText)
                    .font(.caption)
                    .foregroundStyle(subTextColor)
                    .lineLimit(2)

                Text(memo.category.title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(appState.currentPalette.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.10 : 0.16))
                    .clipShape(Capsule())
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(actionCardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    // MARK: - Projects

    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionTitle("진행 중 프로젝트")

                Spacer()

                Button("전체보기") {
                    appState.switchTab(.projects)
                }
                .font(.caption)
                .fontWeight(.semibold)
            }

            if appState.projects.isEmpty {
                emptyProjectView
            } else {
                VStack(spacing: 10) {
                    ForEach(appState.projects.prefix(3)) { project in
                        projectRow(project)
                    }
                }
            }
        }
    }

    private var emptyProjectView: some View {
        VStack(spacing: 10) {
            Image(systemName: "folder.badge.plus")
                .font(.largeTitle)
                .foregroundStyle(appState.currentPalette.primary)

            Text("아직 프로젝트가 없어")
                .font(.headline)
                .foregroundStyle(cardTextColor)

            Text("프로젝트 탭에서 새 프로젝트를 추가해줘.")
                .font(.caption)
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(actionCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func projectRow(_ project: MandukProject) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                if project.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }

                Text(project.title)
                    .font(.headline)
                    .foregroundStyle(cardTextColor)
                    .lineLimit(1)

                Spacer()

                Text("\(Int(project.progress))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(subTextColor)
            }

            if !project.detail.isEmpty {
                Text(project.detail)
                    .font(.caption)
                    .foregroundStyle(subTextColor)
                    .lineLimit(2)
            }

            ProgressView(value: project.progress, total: 100)
                .tint(appState.currentPalette.primary)
        }
        .padding(14)
        .background(actionCardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    // MARK: - Common

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(headerTextColor)
    }

    private var headerTextColor: Color {
        appState.currentPalette.textPrimary
    }

    private var cardTextColor: Color {
        appState.currentPalette.textPrimary
    }

    private var subTextColor: Color {
        appState.currentPalette.textSecondary
    }

    private var heroBackground: some View {
        let palette = appState.currentPalette

        return RoundedRectangle(cornerRadius: 26, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        palette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.95 : 0.45),
                        palette.cardBackground.opacity(appState.selectedStyle == .ios ? 0.85 : 0.72),
                        palette.primary.opacity(appState.selectedStyle == .ios ? 0.06 : 0.18)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private var actionCardBackground: some View {
        let palette = appState.currentPalette

        return RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        palette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.92 : 0.35),
                        palette.cardBackground.opacity(appState.selectedStyle == .ios ? 0.82 : 0.68)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
