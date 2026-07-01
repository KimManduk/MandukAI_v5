import SwiftUI

@main
struct MandukAIApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appState.theme.colorScheme)
        }
    }
}
