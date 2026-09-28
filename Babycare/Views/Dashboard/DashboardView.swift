import SwiftUI
import SwiftData

/// 首页：今日概览 + 今日喂养时间线
struct DashboardView: View {
    @Query private var babies: [Baby]
    @Query(sort: \FeedRecord.timestamp, order: .reverse) private var records: [FeedRecord]
    @State private var showAddFeed = false

    private var baby: Baby? { babies.first }

    private var todayRecords: [FeedRecord] {
        records.filter { Calendar.current.isDateInToday($0.timestamp) }
    }

    private var summary: TodaySummary {
        FeedStats.todaySummary(records: records)
    }

    private var last: FeedRecord? {
        FeedStats.lastRecord(records)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    summaryCards
                    todaySection
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("宝贝喂养")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddFeed = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Theme.peach)
                    }
                }
            }
            .sheet(isPresented: $showAddFeed) {
                AddFeedView()
            }
        }
    }

    // MARK: - 头部：宝宝信息

    private var header: some View {
        HStack(spacing: 12) {
            Text(baby?.avatarEmoji ?? "👶")
                .font(.system(size: 44))
                .frame(width: 64, height: 64)
                .background(Circle().fill(Theme.card))
                .shadow(color: Theme.cardShadow, radius: 6, y: 3)
            VStack(alignment: .leading, spacing: 2) {
                Text(baby?.name ?? "宝宝")
                    .font(.title2.bold())
                Text("\(baby?.ageText ?? "—") · \(Date.now.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    // MARK: - 今日统计卡片

    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCard(
                title: "今日奶量", value: "\(Int(summary.totalVolume))", unit: "毫升",
                symbol: "mug.fill", color: Theme.sky
            )
            SummaryCard(
                title: "喂养次数", value: "\(summary.count)", unit: "次",
                symbol: "arrow.triangle.2.circlepath", color: Theme.peach
            )
            SummaryCard(
                title: "亲喂时长", value: "\(summary.breastMinutes)", unit: "分钟",
                symbol: "heart.fill", color: Theme.grass
            )
        }
    }

    // MARK: - 今日记录

    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("今日记录")
                    .font(.headline)
                Spacer()
                if let last {
                    Text("上次喂养 \(TimeAgo.text(from: last.timestamp))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            if todayRecords.isEmpty {
                EmptyStateView(onAdd: { showAddFeed = true })
            } else {
                ForEach(Array(todayRecords.prefix(7))) { record in
                    FeedRowView(record: record)
                }
                NavigationLink {
                    HistoryView()
                } label: {
                    HStack {
                        Text(todayRecords.count > 7 ? "还有 \(todayRecords.count - 7) 条记录" : "查看全部历史记录")
                            .font(.subheadline.weight(.semibold))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(Theme.peach)
                    .padding(.top, 4)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    DashboardView()
}
