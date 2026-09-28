import SwiftUI
import SwiftData

/// 历史记录：全部喂养记录，按天分组，时间倒序
struct HistoryView: View {
    @Query(sort: \FeedRecord.timestamp, order: .reverse) private var records: [FeedRecord]

    /// 按天分组（保持时间倒序）
    private var grouped: [DailyRecords] {
        let calendar = Calendar.current
        var days: [Date] = []
        var map: [Date: [FeedRecord]] = [:]
        for record in records {
            let day = calendar.startOfDay(for: record.timestamp)
            if map[day] == nil { days.append(day) }
            map[day, default: []].append(record)
        }
        return days.map { DailyRecords(day: $0, records: map[$0] ?? []) }
    }

    var body: some View {
        ScrollView {
            if records.isEmpty {
                EmptyStateView(
                    onAdd: {},
                    title: "还没有任何记录",
                    subtitle: "去首页记录宝宝的每一次喂养吧",
                    showsButton: false
                )
                .padding(.horizontal, 16)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(grouped) { section in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(section.dayTitle)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(section.records.count) 条")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            ForEach(section.records) { record in
                                FeedRowView(record: record)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
        .background(Theme.cream.ignoresSafeArea())
        .navigationTitle("历史记录")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 按天分组的一天记录
struct DailyRecords: Identifiable {
    let day: Date
    let records: [FeedRecord]
    var id: Date { day }

    var dayTitle: String {
        if Calendar.current.isDateInToday(day) { return "今天" }
        if Calendar.current.isDateInYesterday(day) { return "昨天" }
        return day.formatted(.dateTime.month().day().weekday(.wide))
    }
}
