import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var appState: AppState
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                VStack(spacing: 0) {
                    themedChatHeader
                    messagesView
                    inputBar
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        appState.saveLastAssistantMessageToQuickMemo()
                    } label: {
                        Image(systemName: "note.text.badge.plus")
                            .foregroundStyle(appState.currentPalette.primary)
                    }
                    .disabled(!hasAssistantMessage)

                    Button {
                        appState.clearChat()
                    } label: {
                        Image(systemName: clearIconName)
                            .foregroundStyle(appState.currentPalette.primary)
                    }
                    .disabled(appState.chatMessages.isEmpty || appState.isLoading)
                }
            }
        }
    }

    private var navigationTitle: String {
        switch appState.selectedStyle {
        case .basic:
            return "AI 채팅"
        case .jarvis:
            return "AI Link"
        case .ios:
            return "Messages"
        case .game:
            return "NPC Chat"
        case .mandukMix:
            return "만덕 AI"
        case .cmd:
            return "Terminal Chat"
        case .dev:
            return "ChatConsole"
        }
    }

    private var clearIconName: String {
        switch appState.selectedStyle {
        case .cmd:
            return "xmark.bin.fill"
        case .dev:
            return "trash.slash.fill"
        default:
            return "trash"
        }
    }

    // MARK: - Header

    @ViewBuilder
    private var themedChatHeader: some View {
        switch appState.selectedStyle {
        case .basic:
            standardChatHeader
        case .jarvis:
            jarvisChatHeader
        case .ios:
            iosChatHeader
        case .game:
            gameChatHeader
        case .mandukMix:
            mandukChatHeader
        case .cmd:
            cmdChatHeader
        case .dev:
            devChatHeader
        }
    }

    private var standardChatHeader: some View {
        baseHeader(
            icon: "bubble.left.and.bubble.right.fill",
            title: "\(appState.assistantName) 채팅",
            subtitle: "현재 UI: \(appState.selectedStyle.shortTitle)",
            badge: appState.openAIAPIKey.isEmpty ? "API 필요" : "REAL AI"
        )
    }

    private var jarvisChatHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(appState.currentPalette.primary.opacity(0.18), lineWidth: 12)
                    .frame(width: 86, height: 86)

                Circle()
                    .stroke(appState.currentPalette.primary.opacity(0.50), lineWidth: 1.6)
                    .frame(width: 66, height: 66)

                Image(systemName: "cpu.fill")
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(appState.currentPalette.primary)
            }

            VStack(spacing: 4) {
                Text("AI LINK ONLINE")
                    .font(.system(size: 19, weight: .black, design: .monospaced))
                    .foregroundStyle(textColor)

                Text("\(appState.assistantName) Core와 대화 채널이 연결됐어")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(subTextColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(headerBackground)
        .overlay(headerBorder(cornerRadius: 24))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }

    private var iosChatHeader: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(appState.currentPalette.primary.opacity(0.14))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(appState.currentPalette.primary)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(appState.assistantName)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(textColor)

                Text("iOS 메시지 스타일")
                    .font(.caption)
                    .foregroundStyle(subTextColor)
            }

            Spacer()

            Image(systemName: "video.fill")
                .foregroundStyle(appState.currentPalette.primary)
        }
        .padding(14)
        .background(Color.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 14, x: 0, y: 6)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }

    private var gameChatHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                    .frame(width: 58, height: 58)

                Image(systemName: "person.bubble.fill")
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("NPC · \(appState.assistantName)")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(textColor)

                Text("LV. 7 상담 NPC · 퀘스트 대화 가능")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(appState.currentPalette.accent)
            }

            Spacer()

            Text("TALK")
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.accent)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(appState.currentPalette.accent.opacity(0.14))
                .clipShape(Capsule())
        }
        .padding(14)
        .background(headerBackground)
        .overlay(headerBorder(cornerRadius: 24))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }

    private var mandukChatHeader: some View {
        baseHeader(
            icon: "sparkles",
            title: "만덕 AI 비서",
            subtitle: "앱 개발, 메모, 프로젝트를 같이 정리해줄게",
            badge: appState.openAIAPIKey.isEmpty ? "API 필요" : "OPENAI"
        )
    }

    private var cmdChatHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Circle().fill(Color.red.opacity(0.75)).frame(width: 10, height: 10)
                Circle().fill(Color.orange.opacity(0.80)).frame(width: 10, height: 10)
                Circle().fill(Color.green.opacity(0.85)).frame(width: 10, height: 10)

                Spacer()

                Text("chat.exe")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(subTextColor)
            }

            Text("> connect manduk_ai")
                .font(.system(size: 21, weight: .black, design: .monospaced))
                .foregroundStyle(appState.currentPalette.primary)

            Text("status: online  |  messages: \(appState.chatMessages.count)  |  mode: \(appState.openAIAPIKey.isEmpty ? "need_api_key" : "openai")")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(subTextColor)
        }
        .padding(16)
        .background(headerBackground)
        .overlay(headerBorder(cornerRadius: 22))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }

    private var devChatHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle().fill(Color.red.opacity(0.78)).frame(width: 10, height: 10)
                Circle().fill(Color.yellow.opacity(0.78)).frame(width: 10, height: 10)
                Circle().fill(Color.green.opacity(0.78)).frame(width: 10, height: 10)

                Text("ChatView.swift")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(subTextColor)

                Spacer()

                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundStyle(appState.currentPalette.primary)
            }

            Text("ChatConsole")
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundStyle(textColor)

            Text("let assistant = \"\(appState.assistantName)\"\nlet messageCount = \(appState.chatMessages.count)")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(subTextColor)
                .lineSpacing(4)
        }
        .padding(16)
        .background(headerBackground)
        .overlay(headerBorder(cornerRadius: 22))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }

    private func baseHeader(icon: String, title: String, subtitle: String, badge: String) -> some View {
        let palette = appState.currentPalette

        return HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(MandukTheme.primaryGradient(for: appState.selectedStyle))
                    .frame(width: 52, height: 52)
                    .shadow(color: palette.primary.opacity(0.34), radius: 14, x: 0, y: 7)

                Image(systemName: icon)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(textColor)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(subTextColor)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            Text(badge)
                .font(.caption2.weight(.bold))
                .foregroundStyle(palette.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(palette.primary.opacity(appState.selectedStyle == .ios ? 0.10 : 0.16))
                .clipShape(Capsule())
        }
        .padding(14)
        .background(headerBackground)
        .overlay(headerBorder(cornerRadius: 24))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 6)
    }

    // MARK: - Messages

    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: messageSpacing) {
                    if appState.chatMessages.isEmpty {
                        emptyChatView
                    } else {
                        ForEach(appState.chatMessages) { message in
                            let isUserMessage = message.role == .user

                            messageRowView(
                                content: message.content,
                                isUser: isUserMessage,
                                bubbleView: AnyView(ChatBubbleView(message: message))
                            )
                            .id(message.id)
                        }
                    }

                    if appState.isLoading {
                        thinkingIndicator
                            .id("thinking-indicator")
                    }
                }
                .padding(.horizontal, MandukTheme.Spacing.large)
                .padding(.top, MandukTheme.Spacing.medium)
                .padding(.bottom, MandukTheme.Spacing.large)
            }
            .background(Color.clear)
            .onChange(of: appState.chatMessages) { _, messages in
                guard let lastMessage = messages.last else { return }

                withAnimation(.easeOut(duration: 0.25)) {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
            .onChange(of: appState.isLoading) { _, isLoading in
                guard isLoading else { return }

                withAnimation(.easeOut(duration: 0.25)) {
                    proxy.scrollTo("thinking-indicator", anchor: .bottom)
                }
            }
        }
    }



    private var thinkingIndicator: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Image(systemName: thinkingIconName)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(appState.currentPalette.primary)
                .frame(width: 34, height: 34)
                .background(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.10 : 0.16))
                .clipShape(Circle())

            HStack(spacing: 8) {
                ProgressView()
                    .tint(appState.currentPalette.primary)

                Text(thinkingText)
                    .font(thinkingFont)
                    .foregroundStyle(textColor)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(cardBackground(cornerRadius: appState.selectedStyle == .cmd ? 14 : 18))
            .overlay(
                RoundedRectangle(cornerRadius: appState.selectedStyle == .cmd ? 14 : 18, style: .continuous)
                    .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: appState.selectedStyle == .cmd ? 14 : 18, style: .continuous))

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var thinkingIconName: String {
        switch appState.selectedStyle {
        case .cmd:
            return "terminal.fill"
        case .dev:
            return "chevron.left.forwardslash.chevron.right"
        case .game:
            return "person.bubble.fill"
        case .jarvis:
            return "cpu.fill"
        default:
            return "sparkles"
        }
    }

    private var thinkingText: String {
        switch appState.selectedStyle {
        case .cmd:
            return "running openai request..."
        case .dev:
            return "await assistant.reply()"
        case .game:
            return "NPC가 생각 중..."
        case .jarvis:
            return "AI Core 분석 중..."
        default:
            return "만덕 AI가 생각 중..."
        }
    }

    private var thinkingFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev, .game, .jarvis:
            return .system(size: 12, weight: .black, design: .monospaced)
        default:
            return .subheadline.weight(.semibold)
        }
    }

    private func messageRowView(content: String, isUser: Bool, bubbleView: AnyView) -> AnyView {
        switch appState.selectedStyle {
        case .cmd:
            return AnyView(cmdMessageRow(content: content, isUser: isUser))
        case .dev:
            return AnyView(devMessageRow(content: content, isUser: isUser))
        case .game:
            return AnyView(
                gameMessageWrapper(
                    messageView: bubbleView,
                    isUser: isUser
                )
            )
        case .jarvis:
            return AnyView(
                jarvisMessageWrapper(
                    messageView: bubbleView,
                    isUser: isUser
                )
            )
        default:
            return bubbleView
        }
    }

    private func cmdMessageRow(content: String, isUser: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(isUser ? "> user.input" : "> manduk_ai.output")
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(isUser ? appState.currentPalette.accent : appState.currentPalette.primary)

            Text(content)
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color.black.opacity(isUser ? 0.34 : 0.24))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke((isUser ? appState.currentPalette.accent : appState.currentPalette.primary).opacity(0.26), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func devMessageRow(content: String, isUser: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(isUser ? "// UserMessage.swift" : "// AssistantResponse.swift")
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(isUser ? appState.currentPalette.secondary : appState.currentPalette.primary)

            Text(isUser ? "send(\"\(content)\")" : "return \"\(content)\"")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(cardBackground(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func gameMessageWrapper<MessageContent: View>(
        messageView: MessageContent,
        isUser: Bool
    ) -> some View {
        VStack(alignment: isUser ? .trailing : .leading, spacing: 6) {
            Text(isUser ? "PLAYER" : "NPC · \(appState.assistantName)")
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(isUser ? appState.currentPalette.accent : appState.currentPalette.primary)

            messageView
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }

    private func jarvisMessageWrapper<MessageContent: View>(
        messageView: MessageContent,
        isUser: Bool
    ) -> some View {
        VStack(alignment: isUser ? .trailing : .leading, spacing: 6) {
            Text(isUser ? "USER SIGNAL" : "AI CORE RESPONSE")
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(isUser ? appState.currentPalette.secondary : appState.currentPalette.primary)

            messageView
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }

    private var emptyChatView: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(appState.currentPalette.primary.opacity(appState.selectedStyle == .ios ? 0.11 : 0.18))
                    .frame(width: 74, height: 74)

                Image(systemName: emptyIconName)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(appState.currentPalette.primary)
            }

            VStack(spacing: 6) {
                Text(emptyTitle)
                    .font(emptyTitleFont)
                    .foregroundStyle(textColor)

                Text(emptySubtitle)
                    .font(emptySubtitleFont)
                    .foregroundStyle(subTextColor)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(cardBackground(cornerRadius: emptyCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: emptyCornerRadius, style: .continuous)
                .stroke(appState.currentPalette.cardStroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: emptyCornerRadius, style: .continuous))
        .padding(.top, 22)
    }

    // MARK: - Input

    private var inputBar: some View {
        let palette = appState.currentPalette

        return VStack(spacing: 0) {
            Rectangle()
                .fill(palette.cardStroke)
                .frame(height: 1)
                .opacity(appState.selectedStyle == .ios ? 0.5 : 0.35)

            HStack(alignment: .bottom, spacing: MandukTheme.Spacing.small) {
                TextField(inputPlaceholder, text: $appState.currentInput, axis: .vertical)
                    .focused($isInputFocused)
                    .lineLimit(1...5)
                    .font(inputFont)
                    .foregroundStyle(textColor)
                    .padding(.horizontal, MandukTheme.Spacing.medium)
                    .padding(.vertical, MandukTheme.Spacing.small)
                    .background(inputFieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: inputCornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: inputCornerRadius, style: .continuous)
                            .stroke(isInputFocused ? palette.primary.opacity(0.72) : palette.cardStroke, lineWidth: isInputFocused ? 1.5 : 1)
                    )

                Button {
                    sendMessage()
                } label: {
                    Image(systemName: sendIconName)
                        .font(.system(size: sendIconSize, weight: .semibold))
                        .foregroundStyle(canSend ? palette.primary : subTextColor.opacity(0.45))
                }
                .disabled(!canSend)
            }
            .padding(.horizontal, MandukTheme.Spacing.medium)
            .padding(.vertical, MandukTheme.Spacing.small)
            .background(inputBarBackground)
        }
    }

    private var canSend: Bool {
        !appState.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !appState.isLoading
    }

    private var hasAssistantMessage: Bool {
        appState.chatMessages.contains { $0.role == .assistant }
    }

    private func sendMessage() {
        let text = appState.currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard canSend else { return }

        Task {
            await appState.sendUserMessageToAI(text)
        }
    }


    // MARK: - Style Helpers

    private var textColor: Color {
        appState.currentPalette.textPrimary
    }

    private var subTextColor: Color {
        appState.currentPalette.textSecondary
    }

    private var headerBackground: some View {
        cardBackground(cornerRadius: 24)
    }

    private func headerBorder(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(appState.currentPalette.cardStroke, lineWidth: appState.selectedStyle == .game ? 1.4 : 1)
    }

    private var inputPlaceholder: String {
        switch appState.selectedStyle {
        case .cmd:
            return "> type command..."
        case .dev:
            return "sendMessage(\"...\")"
        case .game:
            return "NPC에게 말 걸기"
        case .ios:
            return "iMessage"
        default:
            return "만덕 AI에게 물어보기"
        }
    }

    private var inputFont: Font {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return .system(size: 14, weight: .semibold, design: .monospaced)
        default:
            return .body
        }
    }

    private var inputCornerRadius: CGFloat {
        switch appState.selectedStyle {
        case .cmd:
            return 14
        case .ios:
            return 22
        default:
            return MandukTheme.Radius.large
        }
    }

    private var sendIconName: String {
        switch appState.selectedStyle {
        case .cmd:
            return "terminal.fill"
        case .dev:
            return "paperplane.circle.fill"
        case .game:
            return "bolt.circle.fill"
        default:
            return "arrow.up.circle.fill"
        }
    }

    private var sendIconSize: CGFloat {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return 31
        default:
            return 35
        }
    }

    private var messageSpacing: CGFloat {
        switch appState.selectedStyle {
        case .cmd, .dev:
            return 12
        default:
            return MandukTheme.Spacing.medium
        }
    }

    private var emptyIconName: String {
        switch appState.selectedStyle {
        case .cmd:
            return "terminal.fill"
        case .dev:
            return "chevron.left.forwardslash.chevron.right"
        case .game:
            return "person.bubble.fill"
        case .jarvis:
            return "cpu.fill"
        default:
            return "sparkles"
        }
    }

    private var emptyTitle: String {
        switch appState.selectedStyle {
        case .cmd:
            return "no chat log"
        case .dev:
            return "No messages yet"
        case .game:
            return "아직 대화 퀘스트가 없어"
        case .jarvis:
            return "AI 링크 대기 중"
        default:
            return "아직 대화가 없어"
        }
    }

    private var emptySubtitle: String {
        switch appState.selectedStyle {
        case .cmd:
            return "아래 입력창에 명령어처럼 입력하면 임시 AI가 응답해."
        case .dev:
            return "sendMessage()를 호출하면 콘솔 응답이 생성돼."
        case .game:
            return "NPC에게 말을 걸면 대화가 시작돼."
        case .jarvis:
            return "첫 메시지를 보내면 AI Core가 응답해."
        default:
            return "아래 입력창에 질문을 보내면 임시 AI 답장이 생성돼."
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
            return .caption
        }
    }

    private var emptyCornerRadius: CGFloat {
        switch appState.selectedStyle {
        case .cmd:
            return 16
        case .ios:
            return 28
        default:
            return 24
        }
    }

    private var inputFieldBackground: some View {
        RoundedRectangle(cornerRadius: inputCornerRadius, style: .continuous)
            .fill(
                appState.selectedStyle == .cmd
                ? Color.black.opacity(0.36)
                : appState.currentPalette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.82 : 0.24)
            )
    }

    private var inputBarBackground: some View {
        let palette = appState.currentPalette

        return Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        appState.selectedStyle == .cmd ? Color.black.opacity(0.74) : palette.backgroundBottom.opacity(appState.selectedStyle == .ios ? 0.88 : 0.74),
                        palette.cardBackground.opacity(appState.selectedStyle == .ios ? 0.92 : 0.68)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea(edges: .bottom)
    }

    private func cardBackground(cornerRadius: CGFloat) -> some View {
        let palette = appState.currentPalette

        return RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        appState.selectedStyle == .cmd ? Color.black.opacity(0.42) : palette.cardHighlight.opacity(appState.selectedStyle == .ios ? 0.94 : 0.40),
                        palette.cardBackground.opacity(appState.selectedStyle == .ios ? 0.86 : 0.72),
                        appState.selectedStyle == .dev ? palette.secondary.opacity(0.10) : palette.primary.opacity(appState.selectedStyle == .ios ? 0.05 : 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

#Preview {
    ChatView()
        .environmentObject(AppState())
}
