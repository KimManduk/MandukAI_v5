import SwiftUI
import PhotosUI
import UIKit

struct AICameraView: View {
    @EnvironmentObject private var appState: AppState

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var selectedImageData: Data?
    @State private var selectedMode: AICameraAnalysisMode = .general
    @State private var analysisResult: AICameraAnalysisResult?
    @State private var isAnalyzing = false
    @State private var isShowingCamera = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: MandukTheme.Spacing.large) {
                        headerSection
                        imagePickerSection
                        modeSection
                        analysisSection
                        saveSection
                    }
                    .padding(.horizontal, MandukTheme.Spacing.large)
                    .padding(.top, MandukTheme.Spacing.large)
                    .padding(.bottom, 90)
                }
            }
            .navigationTitle("AI 카메라")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        resetAnalysis()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .disabled(selectedImage == nil && analysisResult == nil)
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    await loadSelectedPhoto(from: newItem)
                }
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraPickerView { image in
                    selectedImage = image
                    selectedImageData = image.jpegData(compressionQuality: 0.85)
                    analysisResult = nil
                    selectedPhotoItem = nil

                    appState.showToast(
                        title: "촬영 완료",
                        message: "이제 분석 모드를 선택하고 분석할 수 있어.",
                        type: .success
                    )
                }
            }
        }
    }

    private var headerSection: some View {
        GlassCardView {
            HStack(spacing: MandukTheme.Spacing.medium) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.25),
                                    Color.purple.opacity(0.18)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 58, height: 58)

                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundStyle(.blue)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("AI 카메라")
                        .font(.title3.weight(.bold))

                    Text("사진첩 선택, 카메라 촬영, 분석 모드 선택, 메모 저장까지 한 번에 할 수 있어.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
        }
    }

    private var imagePickerSection: some View {
        VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
            sectionTitle("사진")

            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 340)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                    )
            } else {
                emptyImageView
            }

            HStack(spacing: MandukTheme.Spacing.small) {
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("사진첩", systemImage: "photo.on.rectangle.angled")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous))
                }
                .buttonStyle(.plain)

                Button {
                    openCamera()
                } label: {
                    Label("촬영", systemImage: "camera.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.purple)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var emptyImageView: some View {
        VStack(spacing: MandukTheme.Spacing.medium) {
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.secondary)

            VStack(spacing: 6) {
                Text("아직 선택한 사진이 없어")
                    .font(.headline)

                Text("사진첩에서 선택하거나 카메라로 바로 촬영해줘.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 230)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var modeSection: some View {
        VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
            sectionTitle("분석 모드")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: MandukTheme.Spacing.small) {
                    ForEach(AICameraAnalysisMode.allCases) { mode in
                        analysisModeChip(mode)
                    }
                }
                .padding(.vertical, 2)
            }

            Text(selectedMode.promptHint)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 2)
        }
    }

    private func analysisModeChip(_ mode: AICameraAnalysisMode) -> some View {
        Button {
            selectedMode = mode
            analysisResult = nil
        } label: {
            HStack(spacing: 6) {
                Image(systemName: mode.systemImage)
                    .font(.caption.weight(.semibold))

                Text(mode.title)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(selectedMode == mode ? Color.white : Color.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(selectedMode == mode ? Color.blue : Color.primary.opacity(0.08))
            )
        }
        .buttonStyle(.plain)
    }

    private var analysisSection: some View {
        VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
            HStack {
                sectionTitle("분석 결과")

                Spacer()

                if analysisResult != nil {
                    Button("복사") {
                        copyAnalysisResult()
                    }
                    .font(.caption.weight(.semibold))
                }
            }

            GlassCardView {
                VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
                    if isAnalyzing {
                        HStack(spacing: MandukTheme.Spacing.small) {
                            ProgressView()
                            Text("\(selectedMode.title) 중...")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else if let analysisResult {
                        resultView(analysisResult)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("사진을 선택한 뒤 분석 버튼을 눌러줘.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(appState.openAIAPIKey.isEmpty ? "설정에서 OpenAI API 키를 저장하면 실제 사진 분석을 할 수 있어." : "OpenAI Vision으로 실제 사진 분석을 실행할 수 있어.")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }

                    Button {
                        Task {
                            await runAIAnalysis()
                        }
                    } label: {
                        Label(appState.openAIAPIKey.isEmpty ? "API 키 필요" : "\(selectedMode.title) 실행", systemImage: selectedMode.systemImage)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(selectedImage == nil ? Color.gray.opacity(0.25) : Color.purple)
                            .foregroundColor(selectedImage == nil ? Color.secondary : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedImage == nil || isAnalyzing)
                }
            }
        }
    }

    private func resultView(_ result: AICameraAnalysisResult) -> some View {
        VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
            HStack(spacing: 8) {
                Image(systemName: result.mode.systemImage)
                    .foregroundStyle(.blue)

                Text(result.mode.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .clipShape(Capsule())
            }

            Text(result.summary)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            if !result.details.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("세부 분석")
                        .font(.headline)

                    ForEach(result.details, id: \.self) { detail in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.green)
                                .padding(.top, 2)

                            Text(detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private var saveSection: some View {
        VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
            sectionTitle("저장")

            HStack(spacing: MandukTheme.Spacing.small) {
                Button {
                    copyAnalysisResult()
                } label: {
                    Label("복사", systemImage: "doc.on.doc")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(analysisResult == nil ? Color.gray.opacity(0.25) : Color.blue)
                        .foregroundColor(analysisResult == nil ? Color.secondary : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(analysisResult == nil)

                Button {
                    saveAnalysisToMemo()
                } label: {
                    Label("메모 저장", systemImage: "note.text.badge.plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(analysisResult == nil ? Color.gray.opacity(0.25) : Color.green)
                        .foregroundColor(analysisResult == nil ? Color.secondary : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(analysisResult == nil)
            }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
    }

    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            appState.showToast(
                title: "카메라 사용 불가",
                message: "시뮬레이터에서는 카메라 촬영이 안 될 수 있어. 아이폰에서 테스트해줘.",
                type: .warning
            )
            return
        }

        isShowingCamera = true
    }

    @MainActor
    private func loadSelectedPhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                appState.showToast(
                    title: "사진 불러오기 실패",
                    message: "선택한 사진 데이터를 읽을 수 없어.",
                    type: .error
                )
                return
            }

            guard let image = UIImage(data: data) else {
                appState.showToast(
                    title: "사진 변환 실패",
                    message: "이미지 형식이 지원되지 않을 수 있어.",
                    type: .error
                )
                return
            }

            selectedImageData = data
            selectedImage = image
            analysisResult = nil

            appState.showToast(
                title: "사진 선택 완료",
                message: "분석 모드를 선택하고 실행해줘.",
                type: .success
            )
        } catch {
            appState.showToast(
                title: "사진 불러오기 오류",
                message: error.localizedDescription,
                type: .error
            )
        }
    }

    @MainActor
    private func runAIAnalysis() async {
        guard selectedImage != nil else {
            appState.showToast(
                title: "사진이 없어",
                message: "먼저 분석할 사진을 선택해줘.",
                type: .warning
            )
            return
        }

        guard let selectedImageData else {
            appState.showToast(
                title: "사진 데이터가 없어",
                message: "사진을 다시 선택한 뒤 분석해줘.",
                type: .warning
            )
            return
        }

        let apiKey = appState.openAIAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !apiKey.isEmpty else {
            appState.showToast(
                title: "API 키가 필요해",
                message: "설정 탭에서 OpenAI API 키를 먼저 저장해줘.",
                type: .warning
            )
            return
        }

        isAnalyzing = true
        analysisResult = nil

        do {
            let reply = try await requestVisionAnalysis(
                imageData: selectedImageData,
                apiKey: apiKey
            )

            analysisResult = makeAnalysisResult(from: reply)
            isAnalyzing = false

            appState.showToast(
                title: "분석 완료",
                message: "OpenAI Vision 분석 결과가 생성됐어.",
                type: .success
            )
        } catch {
            isAnalyzing = false
            appState.showToast(
                title: "AI 분석 오류",
                message: error.localizedDescription,
                type: .error
            )
        }
    }

    private func requestVisionAnalysis(imageData: Data, apiKey: String) async throws -> String {
        guard let url = URL(string: "https://api.openai.com/v1/responses") else {
            throw AICameraOpenAIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let base64Image = imageData.base64EncodedString()
        let prompt = visionPrompt(for: selectedMode)

        let body = AICameraOpenAIRequest(
            model: appState.openAIModel,
            input: [
                AICameraOpenAIInput(
                    role: "user",
                    content: [
                        AICameraOpenAIContent(type: "input_text", text: prompt, imageURL: nil),
                        AICameraOpenAIContent(type: "input_image", text: nil, imageURL: "data:image/jpeg;base64,\(base64Image)")
                    ]
                )
            ],
            maxOutputTokens: 900
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        if statusCode < 200 || statusCode >= 300 {
            if let apiError = try? JSONDecoder().decode(AICameraOpenAIErrorResponse.self, from: data) {
                throw AICameraOpenAIError.api(apiError.error.message)
            }

            throw AICameraOpenAIError.api("상태 코드 \(statusCode)로 분석 요청이 실패했어.")
        }

        let decodedResponse = try JSONDecoder().decode(AICameraOpenAIResponse.self, from: data)
        let reply = decodedResponse.outputText.trimmingCharacters(in: .whitespacesAndNewlines)

        if reply.isEmpty {
            throw AICameraOpenAIError.emptyResponse
        }

        return reply
    }

    private func visionPrompt(for mode: AICameraAnalysisMode) -> String {
        """
        이 이미지를 한국어로 분석해줘.
        현재 선택된 분석 모드는 \(mode.title)이야.
        분석 힌트는 다음과 같아: \(mode.promptHint)

        형식은 반드시 아래처럼 해줘.
        요약: 한 문장 요약
        세부:
        - 중요한 내용 1
        - 중요한 내용 2
        - 중요한 내용 3
        """
    }

    private func makeAnalysisResult(from reply: String) -> AICameraAnalysisResult {
        let lines = reply
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let summaryLine = lines.first { $0.hasPrefix("요약:") } ?? lines.first ?? "이미지 분석 결과가 생성됐어."
        let summary = summaryLine
            .replacingOccurrences(of: "요약:", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let detailLines = lines
            .filter { $0.hasPrefix("-") || $0.hasPrefix("•") }
            .map {
                $0
                    .replacingOccurrences(of: "-", with: "")
                    .replacingOccurrences(of: "•", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter { !$0.isEmpty }

        let details = detailLines.isEmpty ? [reply] : detailLines

        return AICameraAnalysisResult(
            mode: selectedMode,
            summary: summary,
            details: details
        )
    }

    private func copyAnalysisResult() {
        guard let analysisResult else { return }

        UIPasteboard.general.string = analysisResult.memoContent

        appState.showToast(
            title: "복사 완료",
            message: "분석 결과가 클립보드에 복사됐어.",
            type: .success
        )
    }

    private func saveAnalysisToMemo() {
        guard let analysisResult else { return }

        appState.addQuickMemo(
            title: analysisResult.memoTitle,
            content: analysisResult.memoContent,
            category: analysisResult.recommendedMemoCategory
        )
    }

    private func resetAnalysis() {
        analysisResult = nil
        selectedPhotoItem = nil
        selectedImage = nil
        selectedImageData = nil
        selectedMode = .general
    }
}

#Preview {
    AICameraView()
        .environmentObject(AppState())
}

// MARK: - AICamera OpenAI Models

private struct AICameraOpenAIRequest: Encodable {
    let model: String
    let input: [AICameraOpenAIInput]
    let maxOutputTokens: Int

    enum CodingKeys: String, CodingKey {
        case model
        case input
        case maxOutputTokens = "max_output_tokens"
    }
}

private struct AICameraOpenAIInput: Encodable {
    let role: String
    let content: [AICameraOpenAIContent]
}

private struct AICameraOpenAIContent: Encodable {
    let type: String
    let text: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageURL = "image_url"
    }
}

private struct AICameraOpenAIResponse: Decodable {
    let output: [AICameraOpenAIOutputItem]?

    var outputText: String {
        output?
            .flatMap { $0.content ?? [] }
            .compactMap { $0.text }
            .joined(separator: "\n") ?? ""
    }
}

private struct AICameraOpenAIOutputItem: Decodable {
    let content: [AICameraOpenAIOutputContent]?
}

private struct AICameraOpenAIOutputContent: Decodable {
    let text: String?
}

private struct AICameraOpenAIErrorResponse: Decodable {
    let error: AICameraOpenAIErrorDetail
}

private struct AICameraOpenAIErrorDetail: Decodable {
    let message: String
}

private enum AICameraOpenAIError: LocalizedError {
    case invalidURL
    case emptyResponse
    case api(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "OpenAI 요청 주소를 만들지 못했어."
        case .emptyResponse:
            return "AI 분석 답변이 비어있어."
        case .api(let message):
            return "OpenAI API 오류: \(message)"
        }
    }
}
