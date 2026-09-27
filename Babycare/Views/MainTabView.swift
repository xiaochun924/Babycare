import SwiftUI

/// 主界面：三个 Tab
struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("首页", systemImage: "house.fill") }
            StatsView()
                .tabItem { Label("统计", systemImage: "chart.bar.fill") }
            ProfileView()
                .tabItem { Label("我的", systemImage: "person.crop.circle") }
        }
        .tint(Theme.peach)
    }
}
