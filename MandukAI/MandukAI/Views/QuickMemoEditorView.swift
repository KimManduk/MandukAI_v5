//
//  QuickMemoEditorView.swift
//  MandukAI
//
//  Created by 김민혁 on 6/30/26.
//

import SwiftUI

struct QuickMemoEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    var editingMemo: QuickMemo?

    @State private var title: String
    @State private var content: String
    @State private var category: QuickMemoCategory

    init(editingMemo: QuickMemo? = nil) {
        self.editingMemo = editingMemo
        _title = State(initialValue: editingMemo?.title ?? "")
        _content = State(initialValue: editingMemo?.content ?? "")
        _category = State(initialValue: editingMemo?.category ?? .note)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("기본 정보") {
                    TextField("제목", text: $title)

                    Picker("카테고리", selection: $category) {
                        ForEach(QuickMemoCategory.allCases) { category in
                            Label(category.title, systemImage: category.systemImage)
                                .tag(category)
                        }
                    }
                }

                Section("내용") {
                    TextEditor(text: $content)
                        .frame(minHeight: 180)
                }
            }
            .navigationTitle(editingMemo == nil ? "메모 추가" : "메모 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") {
                        saveMemo()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func saveMemo() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            appState.showToast(
                title: "제목이 비어있어",
                message: "메모 제목을 입력해줘.",
                type: .warning
            )
            return
        }

        if var editingMemo {
            editingMemo.title = trimmedTitle
            editingMemo.content = trimmedContent
            editingMemo.category = category
            appState.updateQuickMemo(editingMemo)
        } else {
            appState.addQuickMemo(
                title: trimmedTitle,
                content: trimmedContent,
                category: category
            )
        }

        dismiss()
    }
}

#Preview {
    QuickMemoEditorView()
        .environmentObject(AppState())
}
