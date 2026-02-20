
import Foundation
import WebKit

final class BoltStrikeCookieStoreManager {
    static let boltStrikeShared = BoltStrikeCookieStoreManager()

    private let dataStore: WKWebsiteDataStore
    private let httpCookieStore: WKHTTPCookieStore

    private init() {
        self.dataStore = WKWebsiteDataStore.default()
        self.httpCookieStore = dataStore.httpCookieStore
    }

    func boltStrikeBootstrap() {
        boltStrikeSyncLegacyCookiesToWebKit()
    }

    func boltStrikePersistCookies() {
        httpCookieStore.getAllCookies { cookies in
            let storage = HTTPCookieStorage.shared
            cookies.forEach { storage.setCookie($0) }
        }
    }

    private func boltStrikeSyncLegacyCookiesToWebKit() {
        let storage = HTTPCookieStorage.shared
        let cookies = storage.cookies ?? []
        cookies.forEach { cookie in
            httpCookieStore.setCookie(cookie)
        }
    }

    func boltStrikeApplyCookies(_ completion: @escaping () -> Void = {}) {
        httpCookieStore.getAllCookies { cookies in
            let storage = HTTPCookieStorage.shared
            cookies.forEach { storage.setCookie($0) }
            completion()
        }
    }
}
