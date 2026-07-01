//
//  QuickMemoView.swift
//  MandukAI
//
//  Created by 김민혁 on 6/29/26.
//

import SwiftUI

struct QuickMemoView: View {
    @EnvironmentObject private var appState: AppState

    @State private var selectedCategory: QuickMemoCategory? = nil
    @State private var isShowingAddSheet = false
    @State private var searchText = ""

    private var filteredMemos: [QuickMemo] {
        let categoryFiltered = appState.quickMemos(for: selectedCategory)
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearchText.isEmpty else {
            return categoryFiltered
        }

        return categoryFiltered.filter { memo in
            memo.title.localizedCaseInsensitiveContains(trimmedSearchText) ||
            memo.content.localizedCaseInsensitiveContains(trimmedSearchText) ||
            memo.category.title.localizedCaseInsensitiveContains(trimmedSearchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView {
                    VStack(alignment: .leading, spacing: MandukTheme.Spacing.large) {
                        headerSection
                        searchSection
                        categorySection
                        memoListSection
                    }
                    .padding(.horizontal, MandukTheme.Spacing.large)
                    .padding(.top, MandukTheme.Spacing.large)
                    .padding(.bottom, 90)
                }
            }
            .navigationTitle("빠른 메모")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                QuickMemoEditorView()
                    .environmentObject(appState)
            }
        }
    }

    private var headerSection: some View {
        GlassCardView {
            VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
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

                        Image(systemName: "note.text.badge.plus")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(.blue)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("빠르게 적고 저장하기")
                            .font(.title3.weight(.bold))

                        Text("아이디어, 코드, 할 일을 바로 기록해둘 수 있어.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 0)
                }

                HStack(spacing: MandukTheme.Spacing.small) {
                    MemoCountBadge(title: "전체", count: appState.quickMemos.count)
                    MemoCountBadge(title: "고정", count: appState.quickMemos.filter { $0.isPinned }.count)
                }
            }
        }
    }

    private var searchSection: some View {
        HStack(spacing: MandukTheme.Spacing.small) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("메모 검색", text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, MandukTheme.Spacing.medium)
        .padding(.vertical, MandukTheme.Spacing.small)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: MandukTheme.Radius.large, style: .continuous))
    }

    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: MandukTheme.Spacing.small) {
                CategoryChip(
                    title: "전체",
                    systemImage: "square.grid.2x2.fill",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }

                ForEach(QuickMemoCategory.allCases) { category in
                    CategoryChip(
                        title: category.title,
                        systemImage: category.systemImage,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var memoListSection: some View {
        VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
            HStack {
                Text("메모 목록")
                    .font(.headline)

                Spacer()

                Text("\(filteredMemos.count)개")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            if filteredMemos.isEmpty {
                EmptyStateView(
                    systemImage: "note.text",
                    title: "아직 메모가 없어",
                    message: "오른쪽 위 + 버튼을 눌러 첫 메모를 만들어봐.",
                    buttonTitle: "메모 추가"
                ) {
                    isShowingAddSheet = true
                }
            } else {
                VStack(spacing: MandukTheme.Spacing.medium) {
                    ForEach(filteredMemos) { memo in
                        QuickMemoCardView(memo: memo)
                            .environmentObject(appState)
                    }
                }
            }
        }
    }
}

private struct QuickMemoCardView: View {
    @EnvironmentObject private var appState: AppState

    let memo: QuickMemo

    @State private var isShowingEditSheet = false

    var body: some View {
        Button {
            isShowingEditSheet = true
        } label: {
            GlassCardView {
                VStack(alignment: .leading, spacing: MandukTheme.Spacing.medium) {
                    HStack(alignment: .top, spacing: MandukTheme.Spacing.medium) {
                        categoryIcon

                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Text(memo.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)

                                if memo.isPinned {
                                    Image(systemName: "pin.fill")
                                        .font(.caption)
                                        .foregroundStyle(.orange)
                                }
                            }

                            Text(memo.previewText)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }

                        Spacer(minLength: 0)

                        Menu {
                            Button {
                                appState.togglePinQuickMemo(memo)
                            } label: {
                                Label(memo.isPinned ? "고정 해제" : "고정", systemImage: memo.isPinned ? "pin.slash" : "pin")
                            }

                            Button {
                                isShowingEditSheet = true
                            } label: {
                                Label("수정", systemImage: "pencil")
                            }

                            Button(role: .destructive) {
                                appState.deleteQuickMemo(memo)
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack(spacing: MandukTheme.Spacing.small) {
                        Text(memo.category.title)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.12))
                            .clipShape(Capsule())

                        Spacer()

                        Text(memo.updatedAt, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingEditSheet) {
            QuickMemoEditorView(editingMemo: memo)
                .environmentObject(appState)
        }
    }

    private var categoryIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.blue.opacity(0.12))
                .frame(width: 44, height: 44)

            Image(systemName: memo.category.systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.blue)
        }
    }
}

private struct MemoCountBadge: View {
    let title: String
    let count: Int

    var body: some View {
        HStack(spacing: 5) {
            Text(title)
            Text("\(count)")
                .fontWeight(.bold)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.thinMaterial)
        .clipShape(Capsule())
    }
}

private struct CategoryChip: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.caption.weight(.semibold))

                Text(title)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.blue : Color.primary.opacity(0.08))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    QuickMemoView()
        .environmentObject(AppState())
}
