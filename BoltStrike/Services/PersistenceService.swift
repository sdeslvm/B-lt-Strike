
import Foundation

final class BoltStrikePersistenceService: @unchecked Sendable {
    private enum Keys {
        static let boltStrikeCachedURL = "zm_cached_final_url"
        static let boltStrikeShouldShowStub = "zm_cached_stub_flag"
    }

    private let defaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    var boltStrikeCachedURL: URL? {
        get {
            guard let urlString = defaults.string(forKey: Keys.boltStrikeCachedURL) else { return nil }
            return URL(string: urlString)
        }
        set {
            defaults.set(newValue?.absoluteString, forKey: Keys.boltStrikeCachedURL)
        }
    }

    var boltStrikeShouldShowStub: Bool {
        get { defaults.bool(forKey: Keys.boltStrikeShouldShowStub) }
        set { defaults.set(newValue, forKey: Keys.boltStrikeShouldShowStub) }
    }

    func boltStrikeClear() {
        defaults.removeObject(forKey: Keys.boltStrikeCachedURL)
        defaults.removeObject(forKey: Keys.boltStrikeShouldShowStub)
    }
}
