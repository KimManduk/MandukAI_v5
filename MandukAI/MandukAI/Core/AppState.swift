import Foundation
import SwiftUI
import Combine

// MARK: - App Tab

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case chat
    case projects
    case tools
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            return "홈"
        case .chat:
            return "AI 채팅"
        case .projects:
            return "프로젝트"
        case .tools:
            return "도구"
        case .settings:
            return "설정"
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .chat:
            return "bubble.left.and.bubble.right.fill"
        case .projects:
            return "folder.fill"
        case .tools:
            return "wrench.and.screwdriver.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

// MARK: - App Theme

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system:
            return "시스템 설정"
        case .light:
            return "라이트 모드"
        case .dark:
            return "다크 모드"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

// MARK: - Toast

struct AppToast: Identifiable, Equatable {
    let id: UUID
    var title: String
    var message: String?
    var type: ToastType

    init(
        id: UUID = UUID(),
        title: String,
        message: String? = nil,
        type: ToastType = .info
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.type = type
    }
}

enum ToastType: String {
    case info
    case success
    case warning
    case error

    var systemImage: String {
        switch self {
        case .info:
            return "info.circle.fill"
        case .success:
            return "checkmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "xmark.octagon.fill"
        }
    }

    var tint: Color {
        switch self {
        case .info:
            return .blue
        case .success:
            return .green
        case .warning:
            return .orange
        case .error:
            return .red
        }
    }
}

// MARK: - Project Model

struct MandukProject: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var detail: String
    var progress: Double
    var isPinned: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        detail: String = "",
        progress: Double = 0,
        isPinned: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.progress = progress
        self.isPinned = isPinned
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Chat Message Model

struct MandukChatMessage: Identifiable, Codable, Equatable {
    enum Role: String, Codable {
        case user
        case assistant
        case system
    }

    var id: UUID
    var role: Role
    var content: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        role: Role,
        content: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.createdAt = createdAt
    }
}

// MARK: - App State

@MainActor
final class AppState: ObservableObject {

    // MARK: Navigation

    @Published var selectedTab: AppTab = .home
    @Published var path: [String] = []

    // MARK: UI State

    @Published var theme: AppTheme = .system {
        didSet {
            saveTheme()
        }
    }

    @Published var selectedStyle: AppStyle = MandukTheme.defaultStyle {
        didSet {
            saveSelectedStyle()
        }
    }

    var currentPalette: AppStylePalette {
        MandukTheme.palette(for: selectedStyle)
    }

    @Published var isSidebarOpen: Bool = false
    @Published var isLoading: Bool = false
    @Published var toast: AppToast?

    // MARK: User State

    @Published var userName: String = "만덕"
    @Published var assistantName: String = "만덕 AI"

    // MARK: OpenAI

    @Published var openAIAPIKey: String = "" {
        didSet {
            saveOpenAIAPIKey()
        }
    }

    @Published var openAIModel: String = "gpt-4o-mini"

    // MARK: Projects

    @Published var projects: [MandukProject] = [] {
        didSet {
            saveProjects()
        }
    }

    // MARK: Chat

    @Published var chatMessages: [MandukChatMessage] = [] {
        didSet {
            saveChatMessages()
        }
    }

    @Published var currentInput: String = ""

    // MARK: Quick Memos

    @Published var quickMemos: [QuickMemo] = [] {
        didSet {
            saveQuickMemos()
        }
    }

    // MARK: Storage Keys

    private let themeKey = "mandukai.theme"
    private let selectedStyleKey = "mandukai.selectedStyle"
    private let projectsKey = "mandukai.projects"
    private let chatMessagesKey = "mandukai.chatMessages"
    private let quickMemosKey = "mandukai.quickMemos"
    private let openAIAPIKeyKey = "mandukai.openAIAPIKey"

    // MARK: Init

    init() {
        loadTheme()
        loadSelectedStyle()
        loadProjects()
        loadChatMessages()
        loadQuickMemos()
        loadOpenAIAPIKey()
        seedDefaultDataIfNeeded()
    }

    // MARK: Navigation Actions

    func switchTab(_ tab: AppTab) {
        selectedTab = tab
        isSidebarOpen = false
    }

    func openSidebar() {
        isSidebarOpen = true
    }

    func closeSidebar() {
        isSidebarOpen = false
    }

    func toggleSidebar() {
        isSidebarOpen.toggle()
    }

    // MARK: Loading

    func startLoading() {
        isLoading = true
    }

    func stopLoading() {
        isLoading = false
    }

    // MARK: Toast Actions

    func showToast(
        title: String,
        message: String? = nil,
        type: ToastType = .info
    ) {
        toast = AppToast(
            title: title,
            message: message,
            type: type
        )
    }

    func clearToast() {
        toast = nil
    }

    // MARK: Project Actions

    func addProject(title: String, detail: String = "") {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            showToast(
                title: "프로젝트 이름이 비어있어",
                message: "이름을 입력한 뒤 다시 저장해줘.",
                type: .warning
            )
            return
        }

        let project = MandukProject(
            title: trimmedTitle,
            detail: detail,
            progress: 0,
            isPinned: false
        )

        projects.insert(project, at: 0)

        showToast(
            title: "프로젝트 추가 완료",
            message: "\(trimmedTitle)이 추가됐어.",
            type: .success
        )
    }

    func updateProject(_ project: MandukProject) {
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
            return
        }

        var updatedProject = project
        updatedProject.updatedAt = Date()

        projects[index] = updatedProject
    }

    func updateProjectTitleAndDetail(_ project: MandukProject, title: String, detail: String) {
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
            return
        }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetail = detail.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            showToast(
                title: "프로젝트 이름이 비어있어",
                message: "제목을 입력한 뒤 다시 저장해줘.",
                type: .warning
            )
            return
        }

        projects[index].title = trimmedTitle
        projects[index].detail = trimmedDetail
        projects[index].updatedAt = Date()

        showToast(
            title: "프로젝트 수정 완료",
            message: "제목과 설명을 저장했어.",
            type: .success
        )
    }

    func markProjectCompleted(_ project: MandukProject) {
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
            return
        }

        projects[index].progress = 100
        projects[index].updatedAt = Date()

        showToast(
            title: "프로젝트 완료 처리",
            message: "\(projects[index].title)을 완료로 표시했어.",
            type: .success
        )
    }

    func askAIForProjectNextSteps(
        project: MandukProject,
        status: String,
        tasks: [String],
        logs: [String]
    ) async {
        let taskText = tasks.isEmpty ? "할 일 없음" : tasks.joined(separator: "\n")
        let logText = logs.isEmpty ? "개발 로그 없음" : logs.joined(separator: "\n")

        let prompt = """
        아래 프로젝트의 다음 작업을 추천해줘.

        프로젝트 제목: \(project.title)
        프로젝트 설명: \(project.detail.isEmpty ? "설명 없음" : project.detail)
        진행률: \(Int(project.progress))%
        상태: \(status)

        할 일 목록:
        \(taskText)

        개발 로그:
        \(logText)

        답변 형식:
        1. 지금 가장 먼저 할 일
        2. 다음 작업 3개
        3. 주의할 점
        4. 오늘 바로 할 수 있는 한 가지
        """

        selectedTab = .chat
        await sendUserMessageToAI(prompt)
    }

    func deleteProject(_ project: MandukProject) {
        projects.removeAll { $0.id == project.id }

        showToast(
            title: "프로젝트 삭제 완료",
            message: "\(project.title)이 삭제됐어.",
            type: .success
        )
    }

    func togglePinProject(_ project: MandukProject) {
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
            return
        }

        projects[index].isPinned.toggle()
        projects[index].updatedAt = Date()

        sortProjects()
    }

    func updateProjectProgress(_ project: MandukProject, progress: Double) {
        guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
            return
        }

        let safeProgress = min(max(progress, 0), 100)

        projects[index].progress = safeProgress
        projects[index].updatedAt = Date()
    }

    func sortProjects() {
        projects.sort { first, second in
            if first.isPinned != second.isPinned {
                return first.isPinned && !second.isPinned
            }

            return first.updatedAt > second.updatedAt
        }
    }

    // MARK: Chat Actions

    func sendUserMessage(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            return
        }

        let message = MandukChatMessage(
            role: .user,
            content: trimmedText
        )

        chatMessages.append(message)
        currentInput = ""
    }

    func addAssistantMessage(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            return
        }

        let message = MandukChatMessage(
            role: .assistant,
            content: trimmedText
        )

        chatMessages.append(message)
    }

    func addSystemMessage(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            return
        }

        let message = MandukChatMessage(
            role: .system,
            content: trimmedText
        )

        chatMessages.append(message)
    }

    func saveLastAssistantMessageToQuickMemo() {
        guard let lastAssistantMessage = chatMessages.last(where: { $0.role == .assistant }) else {
            showToast(
                title: "저장할 답변이 없어",
                message: "AI 답변을 받은 뒤 다시 눌러줘.",
                type: .warning
            )
            return
        }

        addQuickMemo(
            title: "AI 답변 메모",
            content: lastAssistantMessage.content,
            category: .note
        )
    }

    func sendUserMessageToAI(_ text: String) async {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            return
        }

        guard !isLoading else {
            showToast(
                title: "답변 생성 중",
                message: "AI 답변이 끝난 뒤 다시 보내줘.",
                type: .info
            )
            return
        }

        let userMessage = MandukChatMessage(
            role: .user,
            content: trimmedText
        )

        chatMessages.append(userMessage)
        currentInput = ""

        await requestOpenAIReply()
    }

    private func requestOpenAIReply() async {
        let trimmedKey = openAIAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedKey.isEmpty else {
            isLoading = false
            addAssistantMessage("OpenAI API 키가 아직 없어. 설정 화면에 API 키 입력칸을 만든 다음 키를 저장하면 실제 AI 답변을 받을 수 있어.")
            showToast(
                title: "API 키가 필요해",
                message: "다음 단계에서 설정 화면에 API 키 입력칸을 추가하자.",
                type: .warning
            )
            return
        }

        guard let url = URL(string: "https://api.openai.com/v1/responses") else {
            addAssistantMessage("OpenAI 요청 주소를 만들지 못했어.")
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(trimmedKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body = OpenAIResponseRequest(
                model: openAIModel,
                input: makeOpenAIInputMessages(),
                maxOutputTokens: 900
            )

            request.httpBody = try JSONEncoder().encode(body)

            let (data, response) = try await URLSession.shared.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            if statusCode < 200 || statusCode >= 300 {
                let apiError = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data)
                let errorMessage = apiError?.error.message ?? "상태 코드 \(statusCode)로 요청이 실패했어."
                addAssistantMessage("OpenAI API 오류: \(errorMessage)")
                return
            }

            let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            let reply = decodedResponse.outputText.trimmingCharacters(in: .whitespacesAndNewlines)

            if reply.isEmpty {
                addAssistantMessage("AI 답변을 받았지만 표시할 텍스트가 비어있어.")
            } else {
                addAssistantMessage(reply)
            }
        } catch {
            addAssistantMessage("AI 연결 중 오류가 났어: \(error.localizedDescription)")
        }
    }

    private func makeOpenAIInputMessages() -> [OpenAIInputMessage] {
        let systemPrompt = """
        너는 사용자의 개인 iPhone 앱 안에 들어있는 한국어 AI 비서야.
        이름은 \(assistantName)이야.
        사용자의 이름은 \(userName)이야.
        사용자는 코딩 초보라서 답변은 짧고 쉽게, 바로 따라 할 수 있게 알려줘.
        너무 길게 설명하지 말고 필요한 다음 행동을 분명하게 말해줘.
        """

        let recentMessages = chatMessages.suffix(12).map { message in
            OpenAIInputMessage(
                role: message.role.rawValue,
                content: message.content
            )
        }

        return [OpenAIInputMessage(role: "system", content: systemPrompt)] + recentMessages
    }

    func clearChat() {
        chatMessages.removeAll()

        showToast(
            title: "채팅 초기화 완료",
            message: "대화 내용이 삭제됐어.",
            type: .success
        )
    }

    // MARK: Quick Memo Actions

    func addQuickMemo(
        title: String,
        content: String = "",
        category: QuickMemoCategory = .note
    ) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            showToast(
                title: "메모 제목이 비어있어",
                message: "제목을 입력한 뒤 다시 저장해줘.",
                type: .warning
            )
            return
        }

        let memo = QuickMemo(
            title: trimmedTitle,
            content: trimmedContent,
            category: category,
            isPinned: false
        )

        quickMemos.insert(memo, at: 0)

        showToast(
            title: "메모 저장 완료",
            message: "\(trimmedTitle)이 저장됐어.",
            type: .success
        )
    }

    func updateQuickMemo(_ memo: QuickMemo) {
        guard let index = quickMemos.firstIndex(where: { $0.id == memo.id }) else {
            return
        }

        var updatedMemo = memo
        updatedMemo.updatedAt = Date()

        quickMemos[index] = updatedMemo
        sortQuickMemos()
    }

    func deleteQuickMemo(_ memo: QuickMemo) {
        quickMemos.removeAll { $0.id == memo.id }

        showToast(
            title: "메모 삭제 완료",
            message: "\(memo.title)이 삭제됐어.",
            type: .success
        )
    }

    func togglePinQuickMemo(_ memo: QuickMemo) {
        guard let index = quickMemos.firstIndex(where: { $0.id == memo.id }) else {
            return
        }

        quickMemos[index].isPinned.toggle()
        quickMemos[index].updatedAt = Date()

        sortQuickMemos()
    }

    func clearQuickMemos() {
        quickMemos.removeAll()

        showToast(
            title: "메모 초기화 완료",
            message: "빠른 메모가 모두 삭제됐어.",
            type: .success
        )
    }

    func sortQuickMemos() {
        quickMemos.sort { first, second in
            if first.isPinned != second.isPinned {
                return first.isPinned && !second.isPinned
            }

            return first.updatedAt > second.updatedAt
        }
    }

    func quickMemos(for category: QuickMemoCategory?) -> [QuickMemo] {
        guard let category else {
            return quickMemos
        }

        return quickMemos.filter { $0.category == category }
    }

    // MARK: User Settings

    func updateSelectedStyle(_ style: AppStyle) {
        selectedStyle = style

        showToast(
            title: "UI 스타일 변경 완료",
            message: "\(style.shortTitle) 스타일이 적용됐어.",
            type: .success
        )
    }

    func updateUserName(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            showToast(
                title: "이름이 비어있어",
                message: "사용자 이름을 입력해줘.",
                type: .warning
            )
            return
        }

        userName = trimmedName
    }

    func updateAssistantName(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            showToast(
                title: "AI 이름이 비어있어",
                message: "AI 이름을 입력해줘.",
                type: .warning
            )
            return
        }

        assistantName = trimmedName
    }

    func updateOpenAIAPIKey(_ apiKey: String) {
        openAIAPIKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)

        if openAIAPIKey.isEmpty {
            showToast(
                title: "API 키 삭제 완료",
                message: "저장된 OpenAI API 키를 비웠어.",
                type: .info
            )
        } else {
            showToast(
                title: "API 키 저장 완료",
                message: "이제 실제 AI 채팅 연결을 테스트할 수 있어.",
                type: .success
            )
        }
    }

    // MARK: Persistence - Theme

    private func saveTheme() {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
    }

    private func loadTheme() {
        guard let rawValue = UserDefaults.standard.string(forKey: themeKey),
              let savedTheme = AppTheme(rawValue: rawValue) else {
            theme = .system
            return
        }

        theme = savedTheme
    }

    // MARK: Persistence - App Style

    private func saveSelectedStyle() {
        UserDefaults.standard.set(selectedStyle.rawValue, forKey: selectedStyleKey)
    }

    private func loadSelectedStyle() {
        guard let rawValue = UserDefaults.standard.string(forKey: selectedStyleKey),
              let savedStyle = AppStyle(rawValue: rawValue) else {
            selectedStyle = MandukTheme.defaultStyle
            return
        }

        selectedStyle = savedStyle
    }

    // MARK: Persistence - Projects

    private func saveProjects() {
        do {
            let data = try JSONEncoder().encode(projects)
            UserDefaults.standard.set(data, forKey: projectsKey)
        } catch {
            print("프로젝트 저장 실패:", error.localizedDescription)
        }
    }

    private func loadProjects() {
        guard let data = UserDefaults.standard.data(forKey: projectsKey) else {
            projects = []
            return
        }

        do {
            projects = try JSONDecoder().decode([MandukProject].self, from: data)
        } catch {
            print("프로젝트 불러오기 실패:", error.localizedDescription)
            projects = []
        }
    }

    // MARK: Persistence - Chat

    private func saveChatMessages() {
        do {
            let data = try JSONEncoder().encode(chatMessages)
            UserDefaults.standard.set(data, forKey: chatMessagesKey)
        } catch {
            print("채팅 저장 실패:", error.localizedDescription)
        }
    }

    private func loadChatMessages() {
        guard let data = UserDefaults.standard.data(forKey: chatMessagesKey) else {
            chatMessages = []
            return
        }

        do {
            chatMessages = try JSONDecoder().decode([MandukChatMessage].self, from: data)
        } catch {
            print("채팅 불러오기 실패:", error.localizedDescription)
            chatMessages = []
        }
    }

    // MARK: Persistence - Quick Memos

    private func saveQuickMemos() {
        do {
            let data = try JSONEncoder().encode(quickMemos)
            UserDefaults.standard.set(data, forKey: quickMemosKey)
        } catch {
            print("빠른 메모 저장 실패:", error.localizedDescription)
        }
    }

    private func loadQuickMemos() {
        guard let data = UserDefaults.standard.data(forKey: quickMemosKey) else {
            quickMemos = []
            return
        }

        do {
            quickMemos = try JSONDecoder().decode([QuickMemo].self, from: data)
        } catch {
            print("빠른 메모 불러오기 실패:", error.localizedDescription)
            quickMemos = []
        }
    }

    // MARK: Persistence - OpenAI

    private func saveOpenAIAPIKey() {
        UserDefaults.standard.set(openAIAPIKey, forKey: openAIAPIKeyKey)
    }

    private func loadOpenAIAPIKey() {
        openAIAPIKey = UserDefaults.standard.string(forKey: openAIAPIKeyKey) ?? ""
    }

    // MARK: Reset

    func resetAllData() {
        projects.removeAll()
        chatMessages.removeAll()
        quickMemos.removeAll()
        currentInput = ""
        selectedTab = .home
        theme = .system
        selectedStyle = MandukTheme.defaultStyle

        UserDefaults.standard.removeObject(forKey: projectsKey)
        UserDefaults.standard.removeObject(forKey: chatMessagesKey)
        UserDefaults.standard.removeObject(forKey: quickMemosKey)
        UserDefaults.standard.removeObject(forKey: themeKey)
        UserDefaults.standard.removeObject(forKey: selectedStyleKey)
        UserDefaults.standard.removeObject(forKey: openAIAPIKeyKey)
        openAIAPIKey = ""

        seedDefaultDataIfNeeded()

        showToast(
            title: "초기화 완료",
            message: "MandukAI 기본 상태로 돌아왔어.",
            type: .success
        )
    }

    // MARK: Default Data

    private func seedDefaultDataIfNeeded() {
        if projects.isEmpty {
            projects = [
                MandukProject(
                    title: "MandukAI v5",
                    detail: "나만의 iPhone AI 앱 만들기",
                    progress: 10,
                    isPinned: true
                ),
                MandukProject(
                    title: "AI 카메라",
                    detail: "사진을 분석하고 설명해주는 기능",
                    progress: 0,
                    isPinned: false
                ),
                MandukProject(
                    title: "코드 저장소",
                    detail: "내 코드와 프로젝트를 저장하는 공간",
                    progress: 0,
                    isPinned: false
                )
            ]
        }

        if chatMessages.isEmpty {
            chatMessages = [
                MandukChatMessage(
                    role: .assistant,
                    content: "안녕, 나는 만덕 AI야. 오늘 만들 기능을 말해줘!"
                )
            ]
        }

        if quickMemos.isEmpty {
            quickMemos = [
                QuickMemo(
                    title: "Sprint 1B 시작",
                    content: "빠른 메모 기능 만들기: 아이디어, 코드, 프로젝트 메모를 저장한다.",
                    category: .project,
                    isPinned: true
                ),
                QuickMemo(
                    title: "AI 카메라 아이디어",
                    content: "사진을 찍으면 AI가 설명하고 저장해주는 기능으로 확장한다.",
                    category: .idea,
                    isPinned: false
                )
            ]
        }
    }
}

// MARK: - OpenAI Models

private struct OpenAIResponseRequest: Encodable {
    let model: String
    let input: [OpenAIInputMessage]
    let maxOutputTokens: Int

    enum CodingKeys: String, CodingKey {
        case model
        case input
        case maxOutputTokens = "max_output_tokens"
    }
}

private struct OpenAIInputMessage: Encodable {
    let role: String
    let content: String
}

private struct OpenAIResponse: Decodable {
    let output: [OpenAIOutputItem]?

    var outputText: String {
        output?
            .flatMap { $0.content ?? [] }
            .compactMap { $0.text }
            .joined(separator: "\n") ?? ""
    }
}

private struct OpenAIOutputItem: Decodable {
    let content: [OpenAIContentItem]?
}

private struct OpenAIContentItem: Decodable {
    let text: String?
}

private struct OpenAIErrorResponse: Decodable {
    let error: OpenAIErrorDetail
}

private struct OpenAIErrorDetail: Decodable {
    let message: String
}
