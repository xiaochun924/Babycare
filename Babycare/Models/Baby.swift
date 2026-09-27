import Foundation
import SwiftData

/// 宝宝档案（MVP 阶段 App 内支持一位宝宝）
@Model
final class Baby {
    var name: String
    var gender: String?
    var birthday: Date?
    var birthWeightKg: Double?
    var birthHeightCm: Double?
    var avatarEmoji: String
    var createdAt: Date

    init(
        name: String = "宝宝",
        gender: String? = nil,
        birthday: Date? = nil,
        birthWeightKg: Double? = nil,
        birthHeightCm: Double? = nil,
        avatarEmoji: String = "👶",
        createdAt: Date = .now
    ) {
        self.name = name
        self.gender = gender
        self.birthday = birthday
        self.birthWeightKg = birthWeightKg
        self.birthHeightCm = birthHeightCm
        self.avatarEmoji = avatarEmoji
        self.createdAt = createdAt
    }
}

extension Baby {
    /// 出生年龄文案，如 "3个月12天"、"1岁2个月"
    var ageText: String {
        guard let birthday else { return "—" }
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month, .day], from: birthday, to: .now)
        let years = comps.year ?? 0
        let months = comps.month ?? 0
        let days = comps.day ?? 0
        if years > 0 {
            return "\(years)岁\(months)个月"
        }
        if months > 0 {
            return "\(months)个月\(days)天"
        }
        return "\(max(days, 0))天"
    }
}
