
import Foundation

struct RemoteLinkParts: Decodable, Sendable {
    let host: String
    let path: String

    private enum CodingKeys: String, CodingKey {
        case host = "man"
        case path = "transfer"
    }
}

struct BackendLinkResponse: Decodable, Sendable {
    let domain: String
    let tld: String

    private enum CodingKeys: String, CodingKey {
        case domain = "man"
        case tld = "transfer"
    }

    var finalURL: URL? {
        guard !domain.isEmpty, !tld.isEmpty else { return nil }
        return URL(string: "https://\(domain)\(tld)")
    }
}

enum LaunchOutcome: Sendable {
    case showWeb(URL)
    case showStub
    case loading
}
