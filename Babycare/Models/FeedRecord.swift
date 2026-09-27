import Foundation
import SwiftData

/// 一条喂养记录
@Model
final class FeedRecord {
    /// 喂养发生时间
    var timestamp: Date
    /// 类型原始值（FeedType.rawValue）
    var typeRaw: String
    /// 亲喂时长（分钟）
    var durationMin: Int?
    /// 奶量（毫升，奶瓶/水）
    var volumeML: Double?
    /// 喂养侧原始值（FeedSide.rawValue，仅亲喂）
    var sideRaw: String?
    /// 备注 / 辅食内容
    var note: String?
    var createdAt: Date

    init(
        timestamp: Date = .now,
        type: FeedType,
        durationMin: Int? = nil,
        volumeML: Double? = nil,
        side: FeedSide? = nil,
        note: String? = nil,
        createdAt: Date = .now
    ) {
        self.timestamp = timestamp
        self.typeRaw = type.rawValue
        self.durationMin = durationMin
        self.volumeML = volumeML
        self.sideRaw = side?.rawValue
        self.note = note
        self.createdAt = createdAt
    }

    var type: FeedType { FeedType(rawValue: typeRaw) ?? .breast }
    var side: FeedSide? { sideRaw.flatMap(FeedSide.init(rawValue:)) }

    /// 本次喂养的关键数值文案
    var amountText: String {
        switch type {
        case .breast:
            return durationMin.map { "\($0) 分钟" } ?? "亲喂"
        case .bottle, .water:
            return volumeML.map { "\(Int($0.rounded())) 毫升" } ?? "—"
        case .solid:
            return "辅食"
        }
    }

    /// 时间文案（列表用）
    var timeText: String {
        timestamp.formatted(date: .omitted, time: .shortened)
    }
}
