import SwiftUI

/// 空状态（文案可自定义；历史页可隐藏按钮）
struct EmptyStateView: View {
    let onAdd: () -> Void
    var title: String = "今天还没有喂养记录"
    var subtitle: String = "记录每一次母乳、奶瓶、辅食和喝水"
    var showsButton: Bool = true

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "baby.carry")
                .font(.system(size: 44))
                .foregroundStyle(Theme.peach)
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if showsButton {
                Button("开始记录", action: onAdd)
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Theme.peach))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}
