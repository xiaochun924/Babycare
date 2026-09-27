# Babycare 宝贝喂养记录

一个用 **Swift 6** 编写的 iOS 宝贝喂养记录应用，**全部使用苹果官方框架，零第三方依赖**。

## 功能

- 🍼 记录喂养：母乳（亲喂时长 / 喂养侧）、奶瓶（毫升）、辅食、喝水
- 📅 今日概览：今日奶量、喂养次数、亲喂时长、距上次喂养时间
- 📊 喂养统计：近 7 天 / 30 天每日奶量柱状图（Swift Charts）、类型占比环图、汇总卡片
- 👶 宝宝档案：昵称、头像、出生日期、出生体重/身高，自动计算月龄
- 💾 本地持久化：SwiftData（数据仅存于本机）

## 技术栈

| 能力 | 框架 |
|---|---|
| 界面 | SwiftUI |
| 数据持久化 | SwiftData |
| 图表 | Swift Charts |
| 图标 | SF Symbols |
| 反馈 | UIKit（触感反馈） |
| 语言 | Swift 6（严格并发检查） |

最低系统版本：iOS 17.0

## 运行环境

- macOS（Xcode 16+）
- iOS 17.0+ 模拟器或真机

## 运行步骤

1. 用 Xcode 打开 `Babycare.xcodeproj`
2. 选择模拟器，或选择真机并在 Signing & Capabilities 中设置你的开发者 Team
3. 按 `⌘R` 运行

首次启动会引导创建宝宝档案，之后即可开始记录每一次喂养。

## 项目结构

```
Babycare/
├── Babycare.xcodeproj/          # Xcode 工程
└── Babycare/
    ├── BabycareApp.swift        # App 入口
    ├── Theme.swift              # 全局配色
    ├── Models/                  # SwiftData 模型（Baby / FeedRecord / FeedType）
    ├── Services/                # 统计计算服务（FeedStats）
    ├── Views/                   # SwiftUI 界面（首页 / 记录 / 统计 / 我的）
    └── Assets.xcassets/         # 图标与主题色
```

## 说明

- 当前 MVP 支持一位宝宝档案，后续可扩展为多宝宝切换与成长记录。
- 所有数据存储在本地 SwiftData 容器中，不上传任何服务器。
