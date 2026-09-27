import SwiftUI
import UIKit

// MARK: - 自适应颜色工具

extension UIColor {
    /// 随系统外观（浅色 / 深色）自适应的 UIColor
    static func adaptive(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        }
    }
}

extension Color {
    /// 随系统外观（浅色 / 深色）自适应的 Color
    static func adaptive(light: UIColor, dark: UIColor) -> Color {
        Color(uiColor: .adaptive(light: light, dark: dark))
    }
}

/// 全局配色与排版常量（全部使用官方框架，无任何第三方依赖）
/// 每个颜色都提供浅色 / 深色两套取值，随系统外观自动切换
enum Theme {
    // MARK: - 背景（浅奶油 / 深墨蓝）
    static let cream = Color.adaptive(
        light: UIColor(red: 1.00, green: 0.97, blue: 0.95, alpha: 1),
        dark: UIColor(red: 0.05, green: 0.07, blue: 0.10, alpha: 1)
    )

    // MARK: - 卡片（白 / 深灰蓝）
    static let card = Color.adaptive(
        light: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1),
        dark: UIColor(red: 0.11, green: 0.14, blue: 0.18, alpha: 1)
    )

    // MARK: - 卡片阴影（浅色淡阴影 / 深色加深阴影）
    static let cardShadow = Color.adaptive(
        light: UIColor(red: 0, green: 0, blue: 0, alpha: 0.06),
        dark: UIColor(red: 0, green: 0, blue: 0, alpha: 0.45)
    )

    // MARK: - 主色：蜜桃粉（深色下更亮，保证对比度）
    static let peach = Color.adaptive(
        light: UIColor(red: 0.98, green: 0.58, blue: 0.54, alpha: 1),
        dark: UIColor(red: 1.00, green: 0.70, blue: 0.66, alpha: 1)
    )
    static let peachDeep = Color.adaptive(
        light: UIColor(red: 0.94, green: 0.44, blue: 0.40, alpha: 1),
        dark: UIColor(red: 1.00, green: 0.62, blue: 0.58, alpha: 1)
    )

    // MARK: - 奶瓶蓝
    static let sky = Color.adaptive(
        light: UIColor(red: 0.47, green: 0.72, blue: 0.94, alpha: 1),
        dark: UIColor(red: 0.60, green: 0.80, blue: 1.00, alpha: 1)
    )

    // MARK: - 辅食绿
    static let grass = Color.adaptive(
        light: UIColor(red: 0.51, green: 0.80, blue: 0.62, alpha: 1),
        dark: UIColor(red: 0.56, green: 0.88, blue: 0.68, alpha: 1)
    )

    // MARK: - 饮水青
    static let aqua = Color.adaptive(
        light: UIColor(red: 0.42, green: 0.78, blue: 0.82, alpha: 1),
        dark: UIColor(red: 0.52, green: 0.86, blue: 0.90, alpha: 1)
    )

    // MARK: - 圆角
    static let cardCorner: CGFloat = 20
}
