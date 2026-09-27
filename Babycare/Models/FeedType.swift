import Foundation
import SwiftUI

/// 喂养类型
enum FeedType: String, CaseIterable, Identifiable, Codable {
    case breast   // 母乳（亲喂）
    case bottle   // 奶瓶（配方奶）
    case solid    // 辅食
    case water    // 水

    var id: String { rawValue }

    var title: String {
        switch self {
        case .breast: "母乳"
        case .bottle: "奶瓶"
        case .solid: "辅食"
        case .water: "水"
        }
    }

    var symbol: String {
        switch self {
        case .breast: "heart.fill"
        case .bottle: "mug.fill"
        case .solid: "fork.knife"
        case .water: "drop.fill"
        }
    }

    var color: Color {
        switch self {
        case .breast: Theme.peach
        case .bottle: Theme.sky
        case .solid: Theme.grass
        case .water: Theme.aqua
        }
    }

    /// 是否需要毫升输入（奶瓶/水）
    var usesVolume: Bool { self == .bottle || self == .water }
    /// 是否需要时长输入（亲喂）
    var usesDuration: Bool { self == .breast }
    /// 是否需要喂养侧输入（亲喂）
    var usesSide: Bool { self == .breast }
}

/// 亲喂侧
enum FeedSide: String, CaseIterable, Identifiable, Codable {
    case left, right, both

    var id: String { rawValue }

    var title: String {
        switch self {
        case .left: "左侧"
        case .right: "右侧"
        case .both: "双侧"
        }
    }

    var symbol: String {
        switch self {
        case .left: "arrow.left"
        case .right: "arrow.right"
        case .both: "arrow.left.and.right"
        }
    }
}
