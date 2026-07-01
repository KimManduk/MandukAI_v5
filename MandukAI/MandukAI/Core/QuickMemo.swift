//
//  QuickMemo.swift
//  MandukAI
//
//  Created by 김민혁 on 6/29/26.
//


import Foundation

enum QuickMemoCategory: String, CaseIterable, Identifiable, Codable {
    case idea
    case code
    case project
    case todo
    case note

    var id: String { rawValue }

    var title: String {
        switch self {
        case .idea:
            return "아이디어"
        case .code:
            return "코드"
        case .project:
            return "프로젝트"
        case .todo:
            return "할 일"
        case .note:
            return "메모"
        }
    }

    var systemImage: String {
        switch self {
        case .idea:
            return "lightbulb.fill"
        case .code:
            return "curlybraces"
        case .project:
            return "folder.fill"
        case .todo:
            return "checklist"
        case .note:
            return "note.text"
        }
    }
}

struct QuickMemo: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var content: String
    var category: QuickMemoCategory
    var isPinned: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        content: String = "",
        category: QuickMemoCategory = .note,
        isPinned: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.isPinned = isPinned
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var previewText: String {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedContent.isEmpty {
            return "내용 없음"
        }

        return trimmedContent
    }
}
