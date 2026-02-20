
import Foundation

enum BoltStrikeLaunchState: Equatable {
    case loading
    case web(url: URL)
    case stub
    case failed
}
