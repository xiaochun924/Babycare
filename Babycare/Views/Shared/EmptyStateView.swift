import SwiftUI

/// 空状态
struct EmptyStateView: View {
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "baby.carry")
                .font(.system(size: 44))
                .foregroundStyle(Theme.peach)
            Text("今天还没有喂养记录")
                .font(.headline)
            Text("记录每一次母乳、奶瓶、辅食和喝水")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button("开始记录", action: onAdd)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Capsule().fill(Theme.peach))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}
