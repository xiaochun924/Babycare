import SwiftUI
import SwiftData

/// 根视图：首次启动引导创建宝宝档案，之后进入主界面
struct RootTabView: View {
    @Query private var babies: [Baby]

    var body: some View {
        if babies.first != nil {
            MainTabView()
        } else {
            BabyProfileSheet(mode: .create)
        }
    }
}
