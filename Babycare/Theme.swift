import SwiftUI

/// 全局配色与排版常量（全部使用官方框架，无任何第三方依赖）
enum Theme {
    // MARK: - 颜色
    static let peach = Color(red: 0.98, green: 0.58, blue: 0.54)     // 主色：蜜桃粉
    static let peachDeep = Color(red: 0.94, green: 0.44, blue: 0.40)
    static let sky = Color(red: 0.47, green: 0.72, blue: 0.94)       // 奶瓶蓝
    static let grass = Color(red: 0.51, green: 0.80, blue: 0.62)     // 辅食绿
    static let aqua = Color(red: 0.42, green: 0.78, blue: 0.82)      // 饮水青
    static let cream = Color(red: 1.00, green: 0.97, blue: 0.95)     // 背景奶油色

    // MARK: - 卡片
    static let cardCorner: CGFloat = 20
    static let cardShadow = Color.black.opacity(0.06)
}
