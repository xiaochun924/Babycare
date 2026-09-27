import SwiftUI

/// 一条喂养记录行
struct FeedRowView: View {
    let record: FeedRecord

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: record.type.symbol)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(record.type.color)
                .frame(width: 40, height: 40)
                .background(RoundedRectangle(cornerRadius: 12).fill(record.type.color.opacity(0.14)))
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(record.type.title)
                        .font(.subheadline.weight(.semibold))
                    if let side = record.side {
                        Text(side.title)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                Text(record.amountText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(record.timeText)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.cardCorner).fill(Color.white))
        .shadow(color: Theme.cardShadow, radius: 6, y: 3)
    }
}
