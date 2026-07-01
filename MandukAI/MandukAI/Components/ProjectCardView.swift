import SwiftUI

struct ProjectCardView: View {
    let project: MandukProject
    var showActions: Bool = true
    var onPin: (() -> Void)?
    var onDelete: (() -> Void)?
    var onProgressChanged: ((Double) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            detailText
            progressSection

            if showActions {
                actionRow
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 8)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(project.isPinned ? Color.yellow.opacity(0.18) : Color.blue.opacity(0.16))
                    .frame(width: 44, height: 44)

                Image(systemName: project.isPinned ? "pin.fill" : "folder.fill")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(project.isPinned ? .yellow : .blue)
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(project.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    if project.isPinned {
                        Text("고정")
                            .font(.caption2.weight(.bold))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color.yellow.opacity(0.18))
                            .foregroundStyle(.yellow)
                            .clipShape(Capsule())
                    }
                }

                Text(updatedText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private var detailText: some View {
        if !project.detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Text(project.detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("진행률")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(Int(project.progress))%")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary)
            }

            ProgressView(value: project.progress, total: 100)
                .tint(progressTint)

            if let onProgressChanged {
                Slider(
                    value: Binding(
                        get: { project.progress },
                        set: { newValue in
                            onProgressChanged(newValue)
                        }
                    ),
                    in: 0...100,
                    step: 5
                )
                .tint(progressTint)
            }
        }
    }

    private var actionRow: some View {
        HStack(spacing: 10) {
            Button {
                onPin?()
            } label: {
                Label(project.isPinned ? "고정 해제" : "고정", systemImage: project.isPinned ? "pin.slash" : "pin")
                    .font(.caption.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)

            Button(role: .destructive) {
                onDelete?()
            } label: {
                Label("삭제", systemImage: "trash")
                    .font(.caption.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.red.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }

    private var cardBackground: some ShapeStyle {
        LinearGradient(
            colors: [
                Color(.secondarySystemBackground).opacity(0.95),
                Color(.secondarySystemBackground).opacity(0.72)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var progressTint: Color {
        if project.progress >= 80 {
            return .green
        } else if project.progress >= 40 {
            return .blue
        } else {
            return .orange
        }
    }

    private var updatedText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.unitsStyle = .short
        return "업데이트 \(formatter.localizedString(for: project.updatedAt, relativeTo: Date()))"
    }
}

#Preview {
    VStack(spacing: 16) {
        ProjectCardView(
            project: MandukProject(
                title: "MandukAI v5",
                detail: "나만의 iPhone AI 앱 만들기",
                progress: 35,
                isPinned: true
            ),
            onPin: {},
            onDelete: {},
            onProgressChanged: { _ in }
        )

        ProjectCardView(
            project: MandukProject(
                title: "AI 카메라",
                detail: "사진을 분석하고 설명해주는 기능",
                progress: 10
            ),
            showActions: false
        )
    }
    .padding()
}
