
import Foundation

struct BoltStrikeRemoteLinkParts: Decodable, Sendable {
    let host: String
    let path: String

    private enum CodingKeys: String, CodingKey {
        case host = "man"
        case path = "transfer"
    }
}

struct BoltStrikeBackendLinkResponse: Decodable, Sendable {
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

enum BoltStrikeLaunchOutcome: Sendable {
    case showWeb(URL)
    case showStub
    case loading
}
