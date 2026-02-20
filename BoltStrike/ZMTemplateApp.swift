
import SwiftUI

@main
struct BoltStrikeApp: App {
    @UIApplicationDelegateAdaptor(BoltStrikeAppDelegate.self) private var appDelegate
    private let dependencies = BoltStrikeAppDependencies()
    
    var body: some Scene {
        WindowGroup {
            BoltStrikeRootView(viewModel: BoltStrikeRootViewModel(launchService: dependencies.launchService))
                .environmentObject(dependencies.webViewCoordinator)
        }
    }
}
