import SwiftUI

@main
struct JMGWorkScapeApp: App {
    @StateObject private var profileManager = ProfileManager()
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(profileManager)
        }
        .modelContainer(for: House.self)
    }
}
