import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject private var appState: AppState

    @State private var newProjectTitle: String = ""
    @State private var newProjectDetail: String = ""
    @State private var isAddSheetPresented: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        themedHeader
                        addProjectButton
                        projectListSection
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                    .padding(.bottom, 90)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddSheetPresented = true
                    } label: {
                        Image(systemName: toolbarAddIcon)
                            .font(.title3)
                            .foregroundStyle(appState.currentPalette.primary)
                    }
                    .accessibilityLabel("프로젝트 추가")
                }
            }
            .sheet(isPresented: $isAddSheetPresented) {
                addProjectSheet
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var navigationTitle: String {
        switch appState.selectedStyle {
        case .basic:
            return "프로젝트"
        case .jarvis:
            return "Mission Core"
        case .ios:
            return "Projects"
        case .game:
            return "Quest Board"
        case .mandukMix:
            return "만덕 프로젝트"
        case .cmd:
            return "process"
        case .dev:
            return "Projects.swift"
        }
    }

    private var toolbarAddIcon: String {
        switch appState.selectedStyle {
        case .cmd:
            return "terminal.fill"
        case .dev:
            return "plus.app.fill"
        case .game:
            return "plus.circle.fill"
        default:
            return "plus.circle.fill"
        }
    }

    // MARK: - Header

    @ViewBuilder
    private var themedHeader: some View {
        switch appState.selectedStyle {
        case .basic:
            normalHeader
        case .jarvis:
            jarvisHeader
        case .ios:
            iosHeader
        case .game:
            gameHeader
        case .mandukMix:
            mandukHeader
        case .cmd:
            cmdHeader
        case .dev:
            devHeader
        }
    }

    private var normalHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("진행 중인 작업")
                        .font(.title2.bold())
                        .foregroundStyle(textColor)

                    Text("만덕 AI에서 만들고 있는 기능들을 한 곳에서 관리해.")
                        .font(.subheadline)
                        .foregroundStyle(subTextColor)
                }

                Spacer()

                headerIcon("folder.badge.gearshape.fill")
            }

            summaryGrid
        }
        .padding(18)
        .background(cardBackground(cornerRadius: 24))
        .overlay(cardBorder(cornerRadius: 24))
    }

    private var jarvisHeader: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(appState.currentPalette.primary.opacity(0.18), lineWidth: 16)
                    .frame(width: 132, height: 132)

                Circle()
                    .stroke(appState.currentPalette.primary.opacity(0.48), lineWidth: 2)
                    .frame(width: 104, height: 104)

                Image(systemName: "scope")
                    .font(.system(size: 42, weight: .black))
                    .foregroundStyle(appState.currentPalette.primary)
            }

            Text("MISSION CORE")
                .font(.system(size: 22, weight: .black, design: .monospaced))
                .foregroundStyle(textColor)

            Text("프로젝트 진행률과 고정 미션을 스캔하고 있어.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(subTextColor)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(cardBackground(cornerRadius: 28))
        .overlay(cardBorder(cornerRadius: 28))
    }

    private var iosHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Projects")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(textColor)

                Text("진행 중인 앱 개발 작업을 위젯처럼 정리했어.")
                    .font(.subheadline)
                    .foregroundStyle(subTextColor)
            }

            HStack(spacing: 12) {
                iosSummaryWidget(title: "전체", value: "\(appState.projects.count)", icon: "folder.fill", tint: .blue)
                iosSummaryWidget(title: "고정", value: "\(pinnedCount)", icon: "pin.fill", tint: .orange)
            }
        }
    }

    private var gameHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                        .frame(width: 76, height: 76)

                    Image(systemName: "flag.checkered")
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("QUEST BOARD")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(textColor)

                    Text("프로젝트를 퀘스트처럼 클리어해보자.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(subTextColor)
                }

                Spacer(minLength: 0)
            }

            summaryGrid
        }
        .padding(18)
        .background(cardBackground(cornerRadius: 26))
        .overlay(cardBorder(cornerRadius: 26))
    }

    private var mandukHeader: some View {
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
                Text("만덕 프로젝트")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(textColor)

                Text("만들 기능과 아이디어를 프로젝트로 모아서 관리해줄게.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(cardBackground(cornerRadius: 28))
        .overlay(cardBorder(cornerRadius: 28))
    }

    private var cmdHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Circle().fill(Color.red.opacity(0.75)).frame(width: 10, height: 10)
                Circle().fill(Color.orange.opacity(0.80)).frame(width: 10, height: 10)
                Circle().fill(Color.green.opacity(0.85)).frame(width: 10, height: 10)
                Spacer()
                Text("projects.exe")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(subTextColor)
            }

            Text("> ps --projects")
                .font(.system(size: 24, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)

            Text("total=\(appState.projects.count)  pinned=\(pinnedCount)  mode=process_list")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(subTextColor)
        }
        .padding(18)
        .background(cardBackground(cornerRadius: 24))
        .overlay(cardBorder(cornerRadius: 24))
    }

    private var devHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle().fill(Color.red.opacity(0.78)).frame(width: 10, height: 10)
                Circle().fill(Color.yellow.opacity(0.78)).frame(width: 10, height: 10)
                Circle().fill(Color.green.opacity(0.78)).frame(width: 10, height: 10)

                Text("ProjectsView.swift")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(subTextColor)

                Spacer()

                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundStyle(appState.currentPalette.primary)
            }

            Text("Projects.swift")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundStyle(textColor)

            Text("let projects = \(appState.projects.count)\nlet pinnedProjects = \(pinnedCount)")
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(subTextColor)
                .lineSpacing(4)
        }
        .padding(18)
        .background(cardBackground(cornerRadius: 24))
        .overlay(cardBorder(cornerRadius: 24))
    }

    private func headerIcon(_ systemImage: String) -> some View {
        ZStack {
            Circle()
                .fill(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.12 : 0.18))
                .frame(width: 52, height: 52)

            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(appState.currentPalette.primary)
        }
    }

    // MARK: - Add Button

    private var addProjectButton: some View {
        Button {
            isAddSheetPresented = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: addButtonIcon)
                    .font(addButtonIconFont)
                    .foregroundStyle(appState.currentPalette.primary)
                    .frame(width: 36, height: 36)
                    .background(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.12 : 0.18))
                    .clipShape(RoundedRectangle(cornerRadius: addIconRadius, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(addButtonTitle)
                        .font(addButtonTitleFont)
                        .foregroundStyle(textColor)

                    Text(addButtonSubtitle)
                        .font(addButtonSubtitleFont)
                        .foregroundStyle(subTextColor)
                }

                Spacer()

                Image(systemName: appState.selectedStyle == .cmd ? "terminal" : "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(subTextColor)
            }
            .padding(16)
            .background(cardBackground(cornerRadius: cardCornerRadius))
            .overlay(cardBorder(cornerRadius: cardCornerRadius))
        }
        .buttonStyle(.plain)
    }

    private var addButtonTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "mkdir new_project"
        case .dev: return "createProject()"
        case .game: return "새 퀘스트 등록"
        case .jarvis: return "NEW MISSION"
        default: return "새 프로젝트 추가"
        }
    }

    private var addButtonSubtitle: String {
        switch appState.selectedStyle {
        case .cmd: return "새 프로세스를 프로젝트 목록에 추가해."
        case .dev: return "새 프로젝트 객체를 생성해."
        case .game: return "아이디어나 만들 기능을 퀘스트로 저장해."
        default: return "아이디어나 만들 기능을 바로 저장해."
        }
    }

    private var addButtonIcon: String {
        switch appState.selectedStyle {
        case .cmd: return "plus.square.fill"
        case .dev: return "plus.app.fill"
        case .game: return "flag.badge.plus"
        default: return "plus"
        }
    }

    // MARK: - Project List

    private var projectListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(projectListTitle)
                .font(sectionTitleFont)
                .foregroundStyle(sectionTitleColor)
                .padding(.horizontal, 2)

            if appState.projects.isEmpty {
                emptyProjectView
            } else {
                VStack(spacing: 12) {
                    ForEach(appState.projects) { project in
                        NavigationLink {
                            ProjectDetailView(project: project)
                                .environmentObject(appState)
                        } label: {
                            ThemedProjectCard(project: project)
                                .environmentObject(appState)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var projectListTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "PROCESS LIST"
        case .dev: return "ProjectFiles"
        case .game: return "QUEST LIST"
        case .jarvis: return "MISSION LIST"
        default: return "프로젝트 목록"
        }
    }

    private var emptyProjectView: some View {
        VStack(spacing: 12) {
            Image(systemName: emptyIcon)
                .font(.largeTitle)
                .foregroundStyle(appState.currentPalette.primary)

            Text(emptyTitle)
                .font(emptyTitleFont)
                .foregroundStyle(textColor)

            Text(emptySubtitle)
                .font(emptySubtitleFont)
                .foregroundStyle(subTextColor)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 34)
        .padding(.horizontal, 18)
        .background(cardBackground(cornerRadius: cardCornerRadius))
        .overlay(cardBorder(cornerRadius: cardCornerRadius))
    }

    private var emptyIcon: String {
        switch appState.selectedStyle {
        case .cmd: return "terminal"
        case .dev: return "folder.badge.questionmark"
        case .game: return "flag.slash"
        case .jarvis: return "scope"
        default: return "tray"
        }
    }

    private var emptyTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "no process found"
        case .dev: return "No project files"
        case .game: return "아직 퀘스트가 없어"
        case .jarvis: return "미션 대기 중"
        default: return "아직 프로젝트가 없어"
        }
    }

    private var emptySubtitle: String {
        switch appState.selectedStyle {
        case .cmd: return "+ 버튼으로 새 프로젝트 프로세스를 추가해줘."
        case .dev: return "createProject()로 첫 프로젝트 파일을 생성해줘."
        case .game: return "오른쪽 위 + 버튼으로 첫 퀘스트를 등록해줘."
        default: return "오른쪽 위 + 버튼을 눌러 첫 프로젝트를 추가해줘."
        }
    }

    // MARK: - Sheet

    private var addProjectSheet: some View {
        NavigationStack {
            Form {
                Section(sheetSectionTitle) {
                    TextField(sheetTitlePlaceholder, text: $newProjectTitle)
                    TextField(sheetDetailPlaceholder, text: $newProjectDetail, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle(sheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        closeAddSheet()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(sheetSaveTitle) {
                        appState.addProject(
                            title: newProjectTitle,
                            detail: newProjectDetail
                        )
                        closeAddSheet()
                    }
                    .disabled(newProjectTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private var sheetTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "mkdir project"
        case .dev: return "New Project"
        case .game: return "퀘스트 등록"
        case .jarvis: return "미션 생성"
        default: return "프로젝트 추가"
        }
    }

    private var sheetSectionTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "project.config"
        case .dev: return "ProjectModel"
        case .game: return "퀘스트 정보"
        default: return "프로젝트 정보"
        }
    }

    private var sheetTitlePlaceholder: String {
        switch appState.selectedStyle {
        case .cmd: return "process.name"
        case .dev: return "project.title"
        case .game: return "퀘스트 이름"
        default: return "프로젝트 이름"
        }
    }

    private var sheetDetailPlaceholder: String {
        switch appState.selectedStyle {
        case .cmd: return "process.description"
        case .dev: return "project.detail"
        case .game: return "퀘스트 설명"
        default: return "설명"
        }
    }

    private var sheetSaveTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "save"
        case .dev: return "create"
        case .game: return "등록"
        default: return "저장"
        }
    }

    private func closeAddSheet() {
        newProjectTitle = ""
        newProjectDetail = ""
        isAddSheetPresented = false
    }

    // MARK: - Helpers

    private var pinnedCount: Int {
        appState.projects.filter { $0.isPinned }.count
    }

    private var summaryGrid: some View {
        HStack(spacing: 10) {
            ThemedProjectSummaryPill(
                title: summaryAllTitle,
                value: "\(appState.projects.count)개",
                systemImage: "square.grid.2x2.fill"
            )
            .environmentObject(appState)

            ThemedProjectSummaryPill(
                title: summaryPinnedTitle,
                value: "\(pinnedCount)개",
                systemImage: "pin.fill"
            )
            .environmentObject(appState)
        }
    }

    private var summaryAllTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "total"
        case .dev: return "projects"
        case .game: return "전체 퀘스트"
        default: return "전체"
        }
    }

    private var summaryPinnedTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "pinned"
        case .dev: return "pinned"
        case .game: return "고정 퀘스트"
        default: return "고정"
        }
    }

    private var textColor: Color { appState.currentPalette.textPrimary }
    private var subTextColor: Color { appState.currentPalette.textSecondary }

    private var sectionTitleColor: Color {
        switch appState.selectedStyle {
        case .cmd, .dev, .jarvis, .game:
            return appState.currentPalette.primary
        default:
            return textColor
        }
    }

    private var sectionTitleFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .jarvis, .game:
            return .system(size: 15, weight: .black, design: .monospaced)
        default:
            return .headline.weight(.bold)
        }
    }

    private var addButtonTitleFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game:
            return .system(size: 14, weight: .black, design: .monospaced)
        default:
            return .headline
        }
    }

    private var addButtonSubtitleFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 11, weight: .semibold, design: .monospaced)
        default:
            return .caption
        }
    }

    private var addButtonIconFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 18, weight: .black, design: .monospaced)
        default:
            return .headline
        }
    }

    private var emptyTitleFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 17, weight: .black, design: .monospaced)
        default:
            return .headline
        }
    }

    private var emptySubtitleFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 12, weight: .semibold, design: .monospaced)
        default:
            return .subheadline
        }
    }

    private var addIconRadius: CGFloat {
        switch appState.selectedStyle {
        case .cmd: return 10
        case .game: return 18
        default: return 18
        }
    }

    private var cardCornerRadius: CGFloat {
        switch appState.selectedStyle {
        case .cmd: return 16
        case .ios: return 28
        default: return 24
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

    private func cardBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.selectedStyle == .cmd ? Color.black.opacity(0.42) : appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.94 : 0.42),
                        appState.currentPalette.cardBackground.opacity(appState.selectedStyle == .ios ? 0.86 : 0.72),
                        appState.selectedStyle == .dev ? appState.currentPalette.secondary.opacity(0.10) : appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.05 : 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func cardBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.cardStroke, lineWidth: appState.selectedStyle == .game ? 1.4 : 1)
    }
}

private struct ThemedProjectSummaryPill: View {
    @EnvironmentObject private var appState: AppState

    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.caption.bold())
                .foregroundStyle(appState.currentPalette.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(appState.currentPalette.textSecondary)

                Text(value)
                    .font(valueFont)
                    .foregroundStyle(appState.currentPalette.textPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(background)
        .overlay(border)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    private var titleFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 10, weight: .bold, design: .monospaced)
        default:
            return .caption2
        }
    }

    private var valueFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game:
            return .system(size: 12, weight: .black, design: .monospaced)
        default:
            return .caption.bold()
        }
    }

    private var cornerRadius: CGFloat {
        appState.selectedStyle == .cmd ? 12 : 16
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(appState.selectedStyle == .cmd ? Color.black.opacity(0.30) : appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.70 : 0.24))
    }

    private var border: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
    }
}

private struct ThemedProjectCard: View {
    @EnvironmentObject private var appState: AppState

    let project: MandukProject

    @State private var localProgress: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                iconBlock

                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 6) {
                        if project.isPinned {
                            Image(systemName: "pin.fill")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }

                        Text(displayTitle)
                            .font(titleFont)
                            .foregroundStyle(appState.currentPalette.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.76)
                    }

                    if !project.detail.isEmpty {
                        Text(displayDetail)
                            .font(detailFont)
                            .foregroundStyle(appState.currentPalette.textSecondary)
                            .lineLimit(2)
                    }
                }

                Spacer()

                menuButton
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(progressTitle)
                        .font(progressFont)
                        .foregroundStyle(appState.currentPalette.textSecondary)

                    Spacer()

                    Text("\(Int(localProgress))%")
                        .font(progressValueFont)
                        .foregroundStyle(appState.currentPalette.primary)
                }

                Slider(value: $localProgress, in: 0...100, step: 5) {
                    Text("진행률")
                } minimumValueLabel: {
                    Text("0")
                        .font(.caption2)
                        .foregroundStyle(appState.currentPalette.textSecondary)
                } maximumValueLabel: {
                    Text("100")
                        .font(.caption2)
                        .foregroundStyle(appState.currentPalette.textSecondary)
                }
                .tint(sliderTint)
                .onChange(of: localProgress) { _, newValue in
                    appState.updateProjectProgress(project, progress: newValue)
                }
            }
        }
        .padding(16)
        .background(cardBackground)
        .overlay(cardBorder)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: shadowColor, radius: appState.selectedStyle == .ios ? 8 : 14, x: 0, y: 8)
        .onAppear {
            localProgress = project.progress
        }
        .onChange(of: project.progress) { _, newValue in
            localProgress = newValue
        }
    }

    private var iconBlock: some View {
        ZStack {
            RoundedRectangle(cornerRadius: iconRadius, style: .continuous)
                .fill(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.12 : 0.18))
                .frame(width: 42, height: 42)

            Image(systemName: iconName)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(appState.currentPalette.primary)
        }
    }

    private var menuButton: some View {
        Menu {
            Button {
                appState.togglePinProject(project)
            } label: {
                Label(
                    project.isPinned ? "고정 해제" : "상단 고정",
                    systemImage: project.isPinned ? "pin.slash" : "pin"
                )
            }

            Button(role: .destructive) {
                appState.deleteProject(project)
            } label: {
                Label("삭제", systemImage: "trash")
            }
        } label: {
            Image(systemName: appState.selectedStyle == .cmd ? "ellipsis" : "ellipsis.circle")
                .font(.title3)
                .foregroundStyle(appState.currentPalette.textSecondary)
        }
    }

    private var displayTitle: String {
        switch appState.selectedStyle {
        case .cmd:
            return "pid_\(abs(project.title.hashValue % 9999)) \(project.title)"
        case .dev:
            return "\(project.title).swift"
        case .game:
            return "QUEST · \(project.title)"
        case .jarvis:
            return "MISSION · \(project.title)"
        default:
            return project.title
        }
    }

    private var displayDetail: String {
        switch appState.selectedStyle {
        case .cmd:
            return "desc: \(project.detail)"
        case .dev:
            return "// \(project.detail)"
        case .game:
            return "퀘스트 설명: \(project.detail)"
        default:
            return project.detail
        }
    }

    private var progressTitle: String {
        switch appState.selectedStyle {
        case .cmd:
            return "progress"
        case .dev:
            return "buildProgress"
        case .game:
            return "클리어율"
        case .jarvis:
            return "MISSION RATE"
        default:
            return "진행률"
        }
    }

    private var iconName: String {
        switch appState.selectedStyle {
        case .cmd:
            return "terminal.fill"
        case .dev:
            return "doc.text.fill"
        case .game:
            return "flag.fill"
        case .jarvis:
            return "scope"
        default:
            return "folder.fill"
        }
    }

    private var titleFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game, .jarvis:
            return .system(size: 14, weight: .black, design: .monospaced)
        default:
            return .headline
        }
    }

    private var detailFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 11, weight: .semibold, design: .monospaced)
        default:
            return .subheadline
        }
    }

    private var progressFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game, .jarvis:
            return .system(size: 11, weight: .bold, design: .monospaced)
        default:
            return .caption
        }
    }

    private var progressValueFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game, .jarvis:
            return .system(size: 12, weight: .black, design: .monospaced)
        default:
            return .caption.bold()
        }
    }

    private var cornerRadius: CGFloat {
        switch appState.selectedStyle {
        case .cmd:
            return 16
        case .ios:
            return 28
        default:
            return 22
        }
    }

    private var iconRadius: CGFloat {
        switch appState.selectedStyle {
        case .cmd:
            return 10
        case .game:
            return 14
        default:
            return 14
        }
    }

    private var sliderTint: Color {
        switch appState.selectedStyle {
        case .game:
            return appState.currentPalette.accent
        default:
            return appState.currentPalette.primary
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.selectedStyle == .cmd ? Color.black.opacity(0.42) : appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.92 : 0.38),
                        appState.currentPalette.cardBackground.opacity(appState.selectedStyle == .ios ? 0.86 : 0.72),
                        appState.selectedStyle == .dev ? appState.currentPalette.secondary.opacity(0.10) : appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.05 : 0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.cardStroke, lineWidth: appState.selectedStyle == .game ? 1.4 : 1)
    }

    private var shadowColor: Color {
        switch appState.selectedStyle {
        case .jarvis:
            return Color.cyan.opacity(0.18)
        case .ios:
            return Color.black.opacity(0.05)
        case .game:
            return Color.purple.opacity(0.22)
        case .cmd:
            return Color.green.opacity(0.16)
        case .dev:
            return Color.blue.opacity(0.16)
        default:
            return Color.black.opacity(0.12)
        }
    }
}

#if DEBUG

private struct ProjectDetailView: View {
    @EnvironmentObject private var appState: AppState

    let project: MandukProject

    @State private var localProgress: Double = 0
    @State private var editTitle: String = ""
    @State private var editDetail: String = ""
    @State private var projectStatus: ProjectDetailStatus = .inProgress
    @State private var quickTaskText: String = ""
    @State private var tasks: [ProjectLocalTask] = []
    @State private var logText: String = ""
    @State private var logs: [String] = []

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    detailHeader
                    editProjectCard
                    progressCard
                    taskCard
                    logCard
                    actionCard
                    memoCard
                }
                .padding(20)
                .padding(.bottom, 90)
            }
        }
        .navigationTitle(detailNavigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            loadProjectDetailData()
        }
        .onChange(of: project.progress) { _, newValue in
            localProgress = newValue
        }
        .onChange(of: tasks) { _, _ in
            saveProjectDetailData()
            syncTaskBasedProgress(showToast: false)
        }
        .onChange(of: logs) { _, _ in
            saveProjectDetailData()
        }
        .onChange(of: projectStatus) { _, _ in
            saveProjectDetailData()
        }
    }

    private var detailNavigationTitle: String {
        switch appState.selectedStyle {
        case .cmd:
            return "project.detail"
        case .dev:
            return "ProjectDetail.swift"
        case .game:
            return "Quest Detail"
        case .jarvis:
            return "Mission Detail"
        default:
            return "프로젝트 상세"
        }
    }

    private var detailHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: iconRadius, style: .continuous)
                        .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                        .frame(width: 62, height: 62)

                    Image(systemName: headerIconName)
                        .font(.system(size: 28, weight: .black))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(displayTitle)
                        .font(titleFont)
                        .foregroundStyle(textColor)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(currentProjectDetail.isEmpty ? "아직 설명이 없어." : currentProjectDetail)
                        .font(detailFont)
                        .foregroundStyle(subTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            HStack(spacing: 8) {
                statusPill(title: "상태", value: projectStatus.title, icon: projectStatus.icon)
                statusPill(title: "진행률", value: "\(Int(localProgress))%", icon: "chart.line.uptrend.xyaxis")
                statusPill(title: "할 일", value: "\(completedTaskCount)/\(tasks.count)", icon: "checklist")
            }
        }
        .padding(18)
        .background(cardBackground(cornerRadius: cardCornerRadius))
        .overlay(cardBorder(cornerRadius: cardCornerRadius))
    }
    private var editProjectCard: some View {
        detailCard(title: editTitleText, icon: "pencil.line") {
            VStack(alignment: .leading, spacing: 12) {
                TextField(editTitlePlaceholder, text: $editTitle)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(inputFont)
                    .foregroundStyle(textColor)
                    .padding(12)
                    .background(fieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
                            .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
                    )

                TextField(editDetailPlaceholder, text: $editDetail, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(inputFont)
                    .foregroundStyle(textColor)
                    .lineLimit(3...6)
                    .padding(12)
                    .background(fieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
                            .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
                    )

                HStack(spacing: 8) {
                    ForEach(ProjectDetailStatus.allCases) { status in
                        Button {
                            projectStatus = status
                        } label: {
                            Label(status.title, systemImage: status.icon)
                                .font(.caption.weight(.bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.72)
                                .padding(.horizontal, 9)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(projectStatus == status ? appState.currentPalette.primary.opacity(0.22) : appState.currentPalette.cardHighlight.opacity(0.18))
                                .foregroundStyle(projectStatus == status ? appState.currentPalette.primary : subTextColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button {
                    saveProjectInfo()
                } label: {
                    Label(saveProjectButtonTitle, systemImage: "checkmark.circle.fill")
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(appState.currentPalette.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                }
                .disabled(editTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    private var actionCard: some View {
        detailCard(title: actionTitle, icon: "bolt.fill") {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    completeProject()
                } label: {
                    Label(completeButtonTitle, systemImage: "checkmark.seal.fill")
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(appState.currentPalette.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                }

                Button {
                    askAIForNextSteps()
                } label: {
                    Label(aiButtonTitle, systemImage: "sparkles")
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.14 : 0.20))
                        .foregroundStyle(appState.currentPalette.primary)
                        .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                }

                Button(role: .destructive) {
                    resetProjectDetailData()
                } label: {
                    Label(resetButtonTitle, systemImage: "arrow.counterclockwise.circle.fill")
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Color.red.opacity(appState.selectedStyle == .ios ? 0.10 : 0.14))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                }
            }
        }
    }

    private var progressCard: some View {
        detailCard(title: progressTitle, icon: "slider.horizontal.3") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(progressSubtitle)
                        .font(captionFont)
                        .foregroundStyle(subTextColor)

                    Spacer()

                    Text("\(Int(localProgress))%")
                        .font(valueFont)
                        .foregroundStyle(appState.currentPalette.primary)
                }

                Slider(value: $localProgress, in: 0...100, step: 5) {
                    Text("진행률")
                }
                .tint(appState.currentPalette.primary)
                .onChange(of: localProgress) { _, newValue in
                    appState.updateProjectProgress(project, progress: newValue)
                }

                Button {
                    applyTaskBasedProgress()
                } label: {
                    Label(taskProgressButtonTitle, systemImage: "checkmark.circle.badge.checkmark")
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.14 : 0.20))
                        .foregroundStyle(appState.currentPalette.primary)
                        .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                }
                .disabled(tasks.isEmpty)
            }
        }
    }

    private var taskCard: some View {
        detailCard(title: taskTitle, icon: "checklist") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    TextField(taskPlaceholder, text: $quickTaskText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(inputFont)
                        .foregroundStyle(textColor)
                        .padding(12)
                        .background(fieldBackground)
                        .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
                                .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
                        )

                    Button {
                        addTask()
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 42, height: 42)
                            .background(appState.currentPalette.primary)
                            .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                    }
                    .disabled(quickTaskText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                VStack(spacing: 10) {
                    ForEach($tasks) { $task in
                        HStack(spacing: 10) {
                            Button {
                                task.isDone.toggle()
                            } label: {
                                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                    .font(.headline)
                                    .foregroundStyle(task.isDone ? appState.currentPalette.primary : subTextColor)
                            }
                            .buttonStyle(.plain)

                            Text(task.title)
                                .font(rowFont)
                                .foregroundStyle(task.isDone ? subTextColor : textColor)
                                .strikethrough(task.isDone, color: subTextColor)

                            Spacer(minLength: 0)

                            Button(role: .destructive) {
                                deleteTask(task.id)
                            } label: {
                                Image(systemName: "trash.fill")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.red)
                                    .frame(width: 32, height: 32)
                                    .background(Color.red.opacity(appState.selectedStyle == .ios ? 0.10 : 0.14))
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(12)
                        .background(appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.52 : 0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
            }
        }
    }

    private var logCard: some View {
        detailCard(title: logTitle, icon: "text.badge.plus") {
            VStack(alignment: .leading, spacing: 12) {
                TextField(logPlaceholder, text: $logText, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(inputFont)
                    .foregroundStyle(textColor)
                    .lineLimit(3...6)
                    .padding(12)
                    .background(fieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
                            .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
                    )

                Button {
                    addLog()
                } label: {
                    Label(logButtonTitle, systemImage: "plus.circle.fill")
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(appState.currentPalette.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                }
                .disabled(logText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                if logs.isEmpty {
                    Text(emptyLogText)
                        .font(.caption)
                        .foregroundStyle(subTextColor)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(logs.indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 10) {
                                Text(logs[index])
                                    .font(rowFont)
                                    .foregroundStyle(textColor)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Button(role: .destructive) {
                                    deleteLog(at: index)
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.red)
                                        .frame(width: 32, height: 32)
                                        .background(Color.red.opacity(appState.selectedStyle == .ios ? 0.10 : 0.14))
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(10)
                            .background(appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.50 : 0.18))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
            }
        }
    }

    private var memoCard: some View {
        detailCard(title: memoTitle, icon: "note.text") {
            VStack(alignment: .leading, spacing: 12) {
                Text(memoDescription)
                    .font(.caption)
                    .foregroundStyle(subTextColor)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    saveProjectSummaryMemo()
                } label: {
                    Label(memoButtonTitle, systemImage: "square.and.pencil")
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.14 : 0.20))
                        .foregroundStyle(appState.currentPalette.primary)
                        .clipShape(RoundedRectangle(cornerRadius: fieldRadius, style: .continuous))
                }
            }
        }
    }

    private func detailCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(appState.currentPalette.primary)

                Text(title)
                    .font(sectionFont)
                    .foregroundStyle(sectionColor)

                Spacer(minLength: 0)
            }

            content()
        }
        .padding(16)
        .background(cardBackground(cornerRadius: cardCornerRadius))
        .overlay(cardBorder(cornerRadius: cardCornerRadius))
    }

    private func statusPill(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(appState.currentPalette.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(subTextColor)

                Text(value)
                    .font(valueFont)
                    .foregroundStyle(textColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.60 : 0.20))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func addTask() {
        let trimmed = quickTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        tasks.append(ProjectLocalTask(title: trimmed))
        quickTaskText = ""
    }

    private func deleteTask(_ id: UUID) {
        tasks.removeAll { $0.id == id }
    }

    private func applyTaskBasedProgress() {
        syncTaskBasedProgress(showToast: true)
    }

    private func syncTaskBasedProgress(showToast: Bool) {
        guard !tasks.isEmpty else { return }

        let progress = Double(completedTaskCount) / Double(tasks.count) * 100
        localProgress = progress.rounded()
        appState.updateProjectProgress(project, progress: localProgress)

        if showToast {
            appState.showToast(
                title: "진행률 반영 완료",
                message: "할 일 완료율 기준으로 \(Int(localProgress))% 적용했어.",
                type: .success
            )
        }
    }

    private func addLog() {
        let trimmed = logText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        logs.insert(trimmed, at: 0)
        logText = ""
    }

    private func deleteLog(at index: Int) {
        guard logs.indices.contains(index) else { return }
        logs.remove(at: index)
    }

    private func saveProjectInfo() {
        appState.updateProjectTitleAndDetail(
            project,
            title: editTitle,
            detail: editDetail
        )
    }

    private func completeProject() {
        projectStatus = .completed
        localProgress = 100
        appState.markProjectCompleted(project)
        saveProjectDetailData()
    }

    private func resetProjectDetailData() {
        tasks = defaultTasks
        logs = []
        projectStatus = .inProgress
        saveProjectDetailData()

        appState.showToast(
            title: "상세 데이터 초기화",
            message: "할 일, 로그, 상태를 초기화했어.",
            type: .success
        )
    }

    private func askAIForNextSteps() {
        let taskLines = tasks.map { task in
            "- \(task.isDone ? "완료" : "미완료"): \(task.title)"
        }

        let logLines = logs.map { "- \($0)" }

        Task {
            await appState.askAIForProjectNextSteps(
                project: project,
                status: projectStatus.title,
                tasks: taskLines,
                logs: logLines
            )
        }
    }

    private func loadProjectDetailData() {
        localProgress = project.progress
        editTitle = project.title
        editDetail = project.detail

        if let savedStatusRawValue = UserDefaults.standard.string(forKey: statusStorageKey),
           let savedStatus = ProjectDetailStatus(rawValue: savedStatusRawValue) {
            projectStatus = savedStatus
        }

        if let taskData = UserDefaults.standard.data(forKey: taskStorageKey),
           let savedTasks = try? JSONDecoder().decode([ProjectLocalTask].self, from: taskData) {
            tasks = savedTasks
        } else if tasks.isEmpty {
            tasks = defaultTasks
        }

        if let logData = UserDefaults.standard.data(forKey: logStorageKey),
           let savedLogs = try? JSONDecoder().decode([String].self, from: logData) {
            logs = savedLogs
        }
    }

    private func saveProjectDetailData() {
        if let taskData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(taskData, forKey: taskStorageKey)
        }

        if let logData = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(logData, forKey: logStorageKey)
        }

        UserDefaults.standard.set(projectStatus.rawValue, forKey: statusStorageKey)
    }

    private var taskStorageKey: String {
        "project_detail_tasks_\(project.id.uuidString)"
    }

    private var logStorageKey: String {
        "project_detail_logs_\(project.id.uuidString)"
    }

    private var statusStorageKey: String {
        "project_detail_status_\(project.id.uuidString)"
    }

    private func saveProjectSummaryMemo() {
        let taskSummary = tasks.map { task in
            "- \(task.isDone ? "✅" : "⬜️") \(task.title)"
        }.joined(separator: "\n")

        let logSummary = logs.isEmpty ? "아직 개발 로그 없음" : logs.map { "- \($0)" }.joined(separator: "\n")

        let content = """
        프로젝트: \(currentProjectTitle)
        설명: \(currentProjectDetail.isEmpty ? "설명 없음" : currentProjectDetail)
        상태: \(projectStatus.title)
        진행률: \(Int(localProgress))%

        할 일:
        \(taskSummary)

        개발 로그:
        \(logSummary)
        """

        appState.addQuickMemo(
            title: "프로젝트 메모 - \(currentProjectTitle)",
            content: content,
            category: .project
        )
    }

    private var defaultTasks: [ProjectLocalTask] {
        [
            ProjectLocalTask(title: "핵심 기능 정리"),
            ProjectLocalTask(title: "화면 테스트"),
            ProjectLocalTask(title: "다음 작업 정하기")
        ]
    }

    private var completedTaskCount: Int {
        tasks.filter { $0.isDone }.count
    }

    private var currentProjectTitle: String {
        editTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? project.title : editTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var currentProjectDetail: String {
        editDetail.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var displayTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "open \(currentProjectTitle)"
        case .dev: return "\(currentProjectTitle).swift"
        case .game: return "QUEST · \(currentProjectTitle)"
        case .jarvis: return "MISSION · \(currentProjectTitle)"
        default: return currentProjectTitle
        }
    }
    private var editTitleText: String {
        switch appState.selectedStyle {
        case .cmd: return "edit.project"
        case .dev: return "EditProject"
        case .game: return "퀘스트 수정"
        case .jarvis: return "MISSION EDIT"
        default: return "제목/설명 수정"
        }
    }

    private var editTitlePlaceholder: String {
        switch appState.selectedStyle {
        case .cmd: return "project.name"
        case .dev: return "project.title"
        case .game: return "퀘스트 이름"
        default: return "프로젝트 제목"
        }
    }

    private var editDetailPlaceholder: String {
        switch appState.selectedStyle {
        case .cmd: return "project.description"
        case .dev: return "project.detail"
        case .game: return "퀘스트 설명"
        default: return "프로젝트 설명"
        }
    }

    private var saveProjectButtonTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "save config"
        case .dev: return "saveProject()"
        case .game: return "수정 저장"
        default: return "제목/설명 저장"
        }
    }
    private var actionTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "project.actions"
        case .dev: return "ProjectActions"
        case .game: return "퀘스트 액션"
        case .jarvis: return "MISSION ACTIONS"
        default: return "프로젝트 액션"
        }
    }

    private var completeButtonTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "mark complete"
        case .dev: return "markCompleted()"
        case .game: return "퀘스트 완료"
        case .jarvis: return "COMPLETE MISSION"
        default: return "프로젝트 완료 처리"
        }
    }

    private var aiButtonTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "ask ai next"
        case .dev: return "askAIForNextSteps()"
        case .game: return "AI에게 다음 퀘스트 묻기"
        case .jarvis: return "ASK AI CORE"
        default: return "AI에게 다음 작업 물어보기"
        }
    }

    private var resetButtonTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "reset detail data"
        case .dev: return "resetDetailData()"
        case .game: return "퀘스트 데이터 초기화"
        default: return "상세 데이터 초기화"
        }
    }

    private var headerIconName: String {
        switch appState.selectedStyle {
        case .cmd: return "terminal.fill"
        case .dev: return "doc.text.fill"
        case .game: return "flag.fill"
        case .jarvis: return "scope"
        default: return "folder.fill"
        }
    }

    private var progressTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "progress.config"
        case .dev: return "buildProgress"
        case .game: return "클리어율"
        case .jarvis: return "MISSION RATE"
        default: return "진행률"
        }
    }

    private var progressSubtitle: String {
        switch appState.selectedStyle {
        case .cmd: return "set progress value"
        case .dev: return "Slider로 진행률 값을 업데이트해."
        case .game: return "퀘스트 클리어율을 조절해."
        default: return "현재 프로젝트 진행 상태를 조절해."
        }
    }

    private var taskProgressButtonTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "sync progress from todo"
        case .dev: return "syncProgressFromTasks()"
        case .game: return "할 일 완료율 반영"
        case .jarvis: return "SYNC MISSION RATE"
        default: return "할 일 기준 진행률 반영"
        }
    }

    private var taskTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "todo.list"
        case .dev: return "TodoList"
        case .game: return "퀘스트 할 일"
        case .jarvis: return "MISSION TODO"
        default: return "할 일 목록"
        }
    }

    private var taskPlaceholder: String {
        switch appState.selectedStyle {
        case .cmd: return "add todo"
        case .dev: return "todo.title"
        case .game: return "새 퀘스트 할 일"
        default: return "새 할 일"
        }
    }

    private var logTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "dev.log"
        case .dev: return "DevelopmentLog"
        case .game: return "진행 기록"
        case .jarvis: return "MISSION LOG"
        default: return "개발 로그"
        }
    }

    private var logPlaceholder: String {
        switch appState.selectedStyle {
        case .cmd: return "write log message"
        case .dev: return "log.message"
        case .game: return "오늘 클리어한 내용"
        default: return "오늘 작업한 내용을 적어줘"
        }
    }

    private var logButtonTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "append log"
        case .dev: return "addLog()"
        case .game: return "기록 추가"
        default: return "로그 추가"
        }
    }

    private var emptyLogText: String {
        switch appState.selectedStyle {
        case .cmd: return "no log found"
        case .dev: return "logs.isEmpty == true"
        case .game: return "아직 진행 기록이 없어."
        default: return "아직 개발 로그가 없어."
        }
    }

    private var memoTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "export.memo"
        case .dev: return "QuickMemoExport"
        case .game: return "퀘스트 기록 저장"
        default: return "프로젝트 메모 저장"
        }
    }

    private var memoDescription: String {
        switch appState.selectedStyle {
        case .cmd: return "현재 프로젝트 상태를 빠른 메모로 export 해."
        case .dev: return "진행률, 할 일, 로그를 QuickMemo로 저장해."
        case .game: return "현재 퀘스트 진행 상황을 기록으로 저장해."
        default: return "진행률, 할 일, 개발 로그를 빠른 메모로 저장해."
        }
    }

    private var memoButtonTitle: String {
        switch appState.selectedStyle {
        case .cmd: return "export"
        case .dev: return "saveMemo()"
        case .game: return "기록 저장"
        default: return "메모로 저장"
        }
    }

    private var textColor: Color { appState.currentPalette.textPrimary }
    private var subTextColor: Color { appState.currentPalette.textSecondary }

    private var titleFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game, .jarvis:
            return .system(size: 22, weight: .black, design: .monospaced)
        default:
            return .title2.bold()
        }
    }

    private var detailFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 12, weight: .semibold, design: .monospaced)
        default:
            return .subheadline
        }
    }

    private var sectionFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game, .jarvis:
            return .system(size: 14, weight: .black, design: .monospaced)
        default:
            return .headline.bold()
        }
    }

    private var rowFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 13, weight: .semibold, design: .monospaced)
        default:
            return .subheadline
        }
    }

    private var inputFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 13, weight: .semibold, design: .monospaced)
        default:
            return .body
        }
    }

    private var valueFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game, .jarvis:
            return .system(size: 12, weight: .black, design: .monospaced)
        default:
            return .caption.bold()
        }
    }

    private var buttonFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game:
            return .system(size: 13, weight: .black, design: .monospaced)
        default:
            return .subheadline.bold()
        }
    }

    private var captionFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 11, weight: .semibold, design: .monospaced)
        default:
            return .caption
        }
    }

    private var sectionColor: Color {
        switch appState.selectedStyle {
        case .cmd, .dev, .game, .jarvis:
            return appState.currentPalette.primary
        default:
            return textColor
        }
    }

    private var iconRadius: CGFloat {
        appState.selectedStyle == .cmd ? 14 : 22
    }

    private var cardCornerRadius: CGFloat {
        switch appState.selectedStyle {
        case .cmd: return 16
        case .ios: return 28
        default: return 24
        }
    }

    private var fieldRadius: CGFloat {
        appState.selectedStyle == .cmd ? 10 : 14
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: fieldRadius, style: .continuous)
            .fill(appState.selectedStyle == .cmd ? Color.black.opacity(0.34) : appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.72 : 0.22))
    }

    private func cardBackground(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.selectedStyle == .cmd ? Color.black.opacity(0.42) : appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.94 : 0.42),
                        appState.currentPalette.cardBackground.opacity(appState.selectedStyle == .ios ? 0.86 : 0.72),
                        appState.selectedStyle == .dev ? appState.currentPalette.secondary.opacity(0.10) : appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.05 : 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private func cardBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.cardStroke, lineWidth: appState.selectedStyle == .game ? 1.4 : 1)
    }
}

private struct ProjectLocalTask: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isDone: Bool

    init(id: UUID = UUID(), title: String, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}

#endif

#Preview {
    ProjectsView()
        .environmentObject(AppState())
}


private enum ProjectDetailStatus: String, CaseIterable, Identifiable, Codable, Equatable {
    case idea
    case inProgress
    case paused
    case completed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .idea:
            return "아이디어"
        case .inProgress:
            return "진행중"
        case .paused:
            return "보류"
        case .completed:
            return "완료"
        }
    }

    var icon: String {
        switch self {
        case .idea:
            return "lightbulb.fill"
        case .inProgress:
            return "play.circle.fill"
        case .paused:
            return "pause.circle.fill"
        case .completed:
            return "checkmark.seal.fill"
        }
    }
}
