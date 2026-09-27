import SwiftUI
import SwiftData

@main
struct BabycareApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [Baby.self, FeedRecord.self])
    }
}
