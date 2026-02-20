
import Foundation
import Combine

@MainActor
final class BoltStrikeRootViewModel: ObservableObject {
    @Published private(set) var state: BoltStrikeLaunchState = .loading
    @Published var errorMessage: String?

    private let launchService: BoltStrikeLaunchService

    init(launchService: BoltStrikeLaunchService) {
        self.launchService = launchService
        state = boltStrikeMapOutcome(launchService.boltStrikeInitialOutcome())
    }

    func boltStrikeStart() {
        Task {
            await boltStrikeExecuteResolve()
        }
    }

    func boltStrikeRetry() {
        errorMessage = nil
        state = .loading
        boltStrikeStart()
    }

    private func boltStrikeExecuteResolve() async {
        let outcome = await launchService.boltStrikeResolveOutcome()
        await MainActor.run {
            self.state = self.boltStrikeMapOutcome(outcome)
            if case .showStub = outcome {
                self.errorMessage = "Failed to obtain link. Showing a placeholder."
            }
        }
    }

    private func boltStrikeMapOutcome(_ outcome: BoltStrikeLaunchOutcome) -> BoltStrikeLaunchState {
        switch outcome {
        case .loading:
            return .loading
        case .showStub:
            return .stub
        case .showWeb(let url):
            return .web(url: url)
        }
    }
}
