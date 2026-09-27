import SwiftUI
import SwiftData
import Charts

/// 某类型的统计条目（用于环图）
struct TypeCount: Identifiable {
    let type: FeedType
    let count: Int
    var id: FeedType { type }
}

/// 统计页：每日奶量柱状图 + 类型占比环图 + 汇总
struct StatsView: View {
    @Query(sort: \FeedRecord.timestamp) private var records: [FeedRecord]
    @State private var range: StatsRange = .sevenDays

    enum StatsRange: String, CaseIterable, Identifiable {
        case sevenDays = "近 7 天"
        case thirtyDays = "近 30 天"

        var id: String { rawValue }

        var days: Int {
            switch self {
            case .sevenDays: 7
            case .thirtyDays: 30
            }
        }
    }

    private var startDate: Date {
        Calendar.current.date(byAdding: .day, value: -(range.days - 1), to: .now) ?? .now
    }

    private var stats: [DailyFeedStat] {
        FeedStats.dailyStats(records: records, in: startDate..<Date.now)
    }

    private var typeCounts: [TypeCount] {
        let recent = records.filter { $0.timestamp >= startDate }
        var counts: [FeedType: Int] = [:]
        for record in recent {
            counts[record.type, default: 0] += 1
        }
        return FeedType.allCases.compactMap { type in
            guard let count = counts[type], count > 0 else { return nil }
            return TypeCount(type: type, count: count)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("范围", selection: $range) {
                        ForEach(StatsRange.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)

                    if records.isEmpty {
                        EmptyStateView(onAdd: {})
                            .padding(.horizontal, 16)
                    } else {
                        dailyVolumeChart
                        typePieChart
                        summaryRow
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("喂养统计")
        }
    }

    // MARK: - 每日奶量柱状图

    private var dailyVolumeChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("每日奶量（毫升）")
                .font(.headline)
            Chart(stats) { item in
                BarMark(
                    x: .value("日期", item.day, unit: .day),
                    y: .value("奶量", item.totalVolume)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Theme.sky, Theme.peach],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(3)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: range == .sevenDays ? 1 : 7)) { _ in
                    AxisGridLine().foregroundStyle(.clear)
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 220)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: Theme.cardCorner).fill(Color.white))
        .shadow(color: Theme.cardShadow, radius: 8, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - 类型占比环图

    private var typePieChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("喂养类型占比")
                .font(.headline)
            if typeCounts.isEmpty {
                Text("暂无数据")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                Chart(typeCounts) { item in
                    SectorMark(
                        angle: .value("次数", item.count),
                        innerRadius: .ratio(0.62),
                        angularInset: 2
                    )
                    .foregroundStyle(item.type.color)
                }
                .frame(height: 180)
                legend
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: Theme.cardCorner).fill(Color.white))
        .shadow(color: Theme.cardShadow, radius: 8, y: 4)
        .padding(.horizontal, 16)
    }

    private var legend: some View {
        HStack(spacing: 12) {
            ForEach(typeCounts) { item in
                HStack(spacing: 5) {
                    Circle().fill(item.type.color).frame(width: 8, height: 8)
                    Text("\(item.type.title) \(item.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 汇总卡片

    private var summaryRow: some View {
        let totalCount = stats.reduce(0) { $0 + $1.feedCount }
        let totalVolume = stats.reduce(0.0) { $0 + $1.totalVolume }
        let totalBreast = stats.reduce(0) { $0 + $1.breastMinutes }

        return HStack(spacing: 12) {
            SummaryCard(
                title: "总记录", value: "\(totalCount)", unit: "次",
                symbol: "list.bullet", color: Theme.peach
            )
            SummaryCard(
                title: "瓶喂/饮水", value: "\(Int(totalVolume))", unit: "毫升",
                symbol: "mug.fill", color: Theme.sky
            )
            SummaryCard(
                title: "亲喂时长", value: "\(totalBreast)", unit: "分钟",
                symbol: "heart.fill", color: Theme.grass
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    StatsView()
}
