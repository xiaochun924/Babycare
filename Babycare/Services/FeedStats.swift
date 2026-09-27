import Foundation

/// 单日聚合统计
struct DailyFeedStat: Identifiable {
    let day: Date
    let feedCount: Int
    let totalVolume: Double    // 奶瓶 + 水（毫升）
    let breastMinutes: Int     // 亲喂总分钟
    let solidCount: Int
    var id: Date { day }
}

/// 今日概览
struct TodaySummary {
    let count: Int
    let totalVolume: Double
    let breastMinutes: Int
    let solidCount: Int
}

/// 统计计算服务（纯函数，Swift 6 并发安全）
enum FeedStats {
    /// 生成 [range) 区间内按天的统计序列（无记录的日期补 0）
    static func dailyStats(
        records: [FeedRecord],
        in range: Range<Date>,
        calendar: Calendar = .current
    ) -> [DailyFeedStat] {
        var grouped: [Date: (count: Int, volume: Double, breast: Int, solid: Int)] = [:]
        for record in records where range.contains(record.timestamp) {
            let day = calendar.startOfDay(for: record.timestamp)
            var entry = grouped[day] ?? (0, 0, 0, 0)
            entry.count += 1
            switch record.type {
            case .bottle, .water:
                entry.volume += record.volumeML ?? 0
            case .breast:
                entry.breast += record.durationMin ?? 0
            case .solid:
                entry.solid += 1
            }
            grouped[day] = entry
        }

        var cursor = calendar.startOfDay(for: range.lowerBound)
        var result: [DailyFeedStat] = []
        while cursor < range.upperBound {
            let entry = grouped[cursor] ?? (0, 0, 0, 0)
            result.append(DailyFeedStat(
                day: cursor,
                feedCount: entry.count,
                totalVolume: entry.volume,
                breastMinutes: entry.breast,
                solidCount: entry.solid
            ))
            cursor = calendar.date(byAdding: .day, value: 1, to: cursor) ?? cursor.addingTimeInterval(86_400)
        }
        return result
    }

    /// 今日汇总
    static func todaySummary(
        records: [FeedRecord],
        calendar: Calendar = .current,
        now: Date = .now
    ) -> TodaySummary {
        var count = 0
        var volume = 0.0
        var breast = 0
        var solid = 0
        for record in records where calendar.isDate(record.timestamp, inSameDayAs: now) {
            count += 1
            switch record.type {
            case .bottle, .water:
                volume += record.volumeML ?? 0
            case .breast:
                breast += record.durationMin ?? 0
            case .solid:
                solid += 1
            }
        }
        return TodaySummary(count: count, totalVolume: volume, breastMinutes: breast, solidCount: solid)
    }

    /// 最近一次喂养记录
    static func lastRecord(_ records: [FeedRecord]) -> FeedRecord? {
        records.max { $0.timestamp < $1.timestamp }
    }
}

/// 相对时间文案
enum TimeAgo {
    static func text(from date: Date, now: Date = .now) -> String {
        let seconds = now.timeIntervalSince(date)
        switch seconds {
        case ..<60:
            return "刚刚"
        case ..<3600:
            return "\(Int(seconds / 60)) 分钟前"
        case ..<86_400:
            return "\(Int(seconds / 3600)) 小时前"
        default:
            return "\(Int(seconds / 86_400)) 天前"
        }
    }
}
