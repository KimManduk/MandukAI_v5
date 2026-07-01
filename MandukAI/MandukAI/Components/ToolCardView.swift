import SwiftUI

struct ToolCardView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    var badgeText: String? = nil
    var isComingSoon: Bool = true
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.22),
                                    Color.purple.opacity(0.16)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 54, height: 54)

                    Image(systemName: systemImage)
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundStyle(.blue)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        if let badgeText {
                            Text(badgeText)
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(
                                    Capsule()
                                        .fill(Color.blue)
                                )
                        }
                    }

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 8) {
                    if isComingSoon {
                        Text("준비중")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.secondary.opacity(0.12))
                            )
                    }

                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 14) {
        ToolCardView(
            title: "AI 카메라",
            subtitle: "사진을 분석하고 설명하는 기능",
            systemImage: "camera.fill",
            badgeText: "AI"
        )

        ToolCardView(
            title: "코드 저장소",
            subtitle: "내 프로젝트 코드와 메모를 저장하는 공간",
            systemImage: "chevron.left.forwardslash.chevron.right",
            isComingSoon: false
        )
    }
    .padding()
}
