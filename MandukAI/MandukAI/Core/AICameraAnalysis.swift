
import Foundation

enum AICameraAnalysisMode: String, CaseIterable, Identifiable, Codable {
    case general
    case object
    case mood
    case text
    case shorts

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general:
            return "전체 분석"
        case .object:
            return "사물 분석"
        case .mood:
            return "분위기 분석"
        case .text:
            return "텍스트 분석"
        case .shorts:
            return "쇼츠 소재"
        }
    }

    var systemImage: String {
        switch self {
        case .general:
            return "sparkles"
        case .object:
            return "cube.fill"
        case .mood:
            return "paintpalette.fill"
        case .text:
            return "text.viewfinder"
        case .shorts:
            return "play.rectangle.fill"
        }
    }

    var promptHint: String {
        switch self {
        case .general:
            return "사진 전체를 보고 주요 피사체, 배경, 분위기를 요약해줘."
        case .object:
            return "사진 속 사물과 인물의 위치, 특징, 관계를 분석해줘."
        case .mood:
            return "사진의 색감, 조명, 분위기, 감정을 중심으로 분석해줘."
        case .text:
            return "사진 속 글자나 간판, 문서 내용을 읽고 요약해줘."
        case .shorts:
            return "이 사진을 유튜브 쇼츠 소재로 쓴다면 제목, 훅, 장면 설명을 만들어줘."
        }
    }
}

struct AICameraAnalysisResult: Identifiable, Codable, Equatable {
    var id: UUID
    var mode: AICameraAnalysisMode
    var summary: String
    var details: [String]
    var recommendedMemoCategory: QuickMemoCategory
    var createdAt: Date

    init(
        id: UUID = UUID(),
        mode: AICameraAnalysisMode,
        summary: String,
        details: [String],
        recommendedMemoCategory: QuickMemoCategory = .idea,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.mode = mode
        self.summary = summary
        self.details = details
        self.recommendedMemoCategory = recommendedMemoCategory
        self.createdAt = createdAt
    }

    var memoTitle: String {
        switch mode {
        case .general:
            return "AI 카메라 전체 분석"
        case .object:
            return "AI 카메라 사물 분석"
        case .mood:
            return "AI 카메라 분위기 분석"
        case .text:
            return "AI 카메라 텍스트 분석"
        case .shorts:
            return "AI 카메라 쇼츠 소재"
        }
    }

    var memoContent: String {
        var lines: [String] = []
        lines.append("[\(mode.title)]")
        lines.append("")
        lines.append(summary)

        if !details.isEmpty {
            lines.append("")
            lines.append("세부 분석")
            details.forEach { detail in
                lines.append("- \(detail)")
            }
        }

        return lines.joined(separator: "\n")
    }
}

enum AICameraTemporaryAnalyzer {
    static func analyze(mode: AICameraAnalysisMode) -> AICameraAnalysisResult {
        switch mode {
        case .general:
            return AICameraAnalysisResult(
                mode: .general,
                summary: "사진 전체를 기준으로 주요 피사체와 배경을 분리해서 볼 수 있어. 실제 AI 연결 전이라 현재는 임시 분석 결과야.",
                details: [
                    "중앙 피사체를 기준으로 장면을 설명할 수 있어.",
                    "배경 요소와 색감을 함께 기록하면 나중에 검색하기 좋아.",
                    "다음 단계에서 실제 이미지 분석 API를 연결하면 더 정확한 설명을 만들 수 있어."
                ],
                recommendedMemoCategory: .idea
            )

        case .object:
            return AICameraAnalysisResult(
                mode: .object,
                summary: "사진 속 사물의 종류, 위치, 개수를 정리하는 분석 모드야.",
                details: [
                    "주요 사물은 화면 중앙 또는 밝은 영역에 있을 가능성이 높아.",
                    "사물별 이름, 특징, 위치를 저장하는 구조로 확장할 수 있어.",
                    "나중에 카메라 기록 검색 기능과 연결하기 좋아."
                ],
                recommendedMemoCategory: .note
            )

        case .mood:
            return AICameraAnalysisResult(
                mode: .mood,
                summary: "사진의 색감, 조명, 분위기를 중심으로 설명하는 모드야.",
                details: [
                    "밝은 사진은 일상 기록이나 상품 설명에 적합해.",
                    "어두운 사진은 미스터리, 감성, 쇼츠 썸네일 소재로 활용할 수 있어.",
                    "분위기 키워드를 자동 태그로 저장하는 기능으로 확장 가능해."
                ],
                recommendedMemoCategory: .idea
            )

        case .text:
            return AICameraAnalysisResult(
                mode: .text,
                summary: "사진 속 문구, 간판, 문서 내용을 읽고 요약하는 모드야. 지금은 OCR 연결 전 임시 결과야.",
                details: [
                    "다음 단계에서 Vision OCR을 붙이면 이미지 속 글자를 추출할 수 있어.",
                    "추출한 텍스트를 메모, 할 일, 코드 기록으로 저장할 수 있어.",
                    "영수증, 안내문, 코드 스크린샷 분석에도 활용 가능해."
                ],
                recommendedMemoCategory: .note
            )

        case .shorts:
            return AICameraAnalysisResult(
                mode: .shorts,
                summary: "이 사진을 쇼츠 소재로 바꾸기 위한 임시 분석 결과야.",
                details: [
                    "추천 훅: 이 사진 속 이상한 점, 보이시나요?",
                    "추천 제목: 사진 한 장에 숨겨진 단서",
                    "장면 구성: 사진 확대 → 단서 강조 → 짧은 해석 → 댓글 유도",
                    "심야기록 스타일의 미스터리 쇼츠 소재로 확장할 수 있어."
                ],
                recommendedMemoCategory: .idea
            )
        }
    }
}
