

import Foundation
import os.log

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "BoltStrike", category: "BoltStrikeLaunchService")

final class BoltStrikeLaunchService {
    private let persistence: BoltStrikePersistenceService
    private let trackingService: BoltStrikeTrackingService
    private let remoteConfigService: BoltStrikeFirebaseRealtimeService
    private let backendClient: BoltStrikeBackendClient
    private let linkAssemblyService: BoltStrikeLinkAssemblyService
    private let cookieStore: BoltStrikeCookieStoreManager
    
    private let stubURL = URL(string: "https://boltstrikex.pro/user")!

    init(persistence: BoltStrikePersistenceService,
         trackingService: BoltStrikeTrackingService,
         remoteConfigService: BoltStrikeFirebaseRealtimeService,
         backendClient: BoltStrikeBackendClient,
         linkAssemblyService: BoltStrikeLinkAssemblyService,
         cookieStore: BoltStrikeCookieStoreManager) {
        self.persistence = persistence
        self.trackingService = trackingService
        self.remoteConfigService = remoteConfigService
        self.backendClient = backendClient
        self.linkAssemblyService = linkAssemblyService
        self.cookieStore = cookieStore
    }

    func boltStrikeInitialOutcome() -> BoltStrikeLaunchOutcome {
        logger.info("[Launch] Checking initial outcome...")
        
        if persistence.boltStrikeShouldShowStub {
            logger.info("[Launch] 🟡 Cached stub flag is TRUE -> showing stub")
            return .showWeb(stubURL)
        }

        if let boltStrikeCachedURL = persistence.boltStrikeCachedURL {
            logger.info("[Launch] ✅ Found cached URL: \(boltStrikeCachedURL.absoluteString) -> showing WebView")
            return .showWeb(boltStrikeCachedURL)
        }

        logger.info("[Launch] 🔄 No cache found -> loading")
        return .loading
    }

    func boltStrikeResolveOutcome() async -> BoltStrikeLaunchOutcome {
        logger.info("[Launch] Resolving outcome...")
        
        if persistence.boltStrikeShouldShowStub {
            logger.info("[Launch] 🟡 Cached stub flag is TRUE -> showing stub (no request needed)")
            return .showWeb(stubURL)
        }

        if let cached = persistence.boltStrikeCachedURL {
            logger.info("[Launch] ✅ Found cached URL: \(cached.absoluteString) -> showing WebView (no request needed)")
            return .showWeb(cached)
        }

        logger.info("[Launch] No cache -> collecting tracking payload...")
        guard let payload = await trackingService.boltStrikeCollectPayload() else {
            logger.error("[Launch] ❌ Failed to collect tracking payload -> showing stub")
            persistence.boltStrikeShouldShowStub = true
            return .showWeb(stubURL)
        }
        logger.info("[Launch] ✅ Tracking payload collected successfully")

        do {
            logger.info("[Launch] Fetching link parts from Firebase...")
            let linkParts = try await remoteConfigService.boltStrikeFetchLinkParts()
            
            guard let backendURL = linkAssemblyService.boltStrikeBuildBackendURL(parts: linkParts, payload: payload) else {
                logger.error("[Launch] ❌ Failed to build backend URL -> showing stub")
                persistence.boltStrikeShouldShowStub = true
                return .showWeb(stubURL)
            }

            logger.info("[Launch] Sending POST request to backend...")
            let response = try await backendClient.boltStrikeRequestFinalLink(url: backendURL)
            
            guard let finalURL = response.finalURL else {
                logger.warning("[Launch] ⚠️ Backend returned empty domain/tld -> showing stub")
                logger.info("[Launch] Reason: domain='\(response.domain)', tld='\(response.tld)'")
                persistence.boltStrikeShouldShowStub = true
                return .showWeb(stubURL)
            }

            logger.info("[Launch] ✅ SUCCESS! Final URL: \(finalURL.absoluteString)")
            logger.info("[Launch] Caching URL and showing WebView")
            persistence.boltStrikeCachedURL = finalURL
            persistence.boltStrikeShouldShowStub = false
            cookieStore.boltStrikePersistCookies()
            return .showWeb(finalURL)
        } catch {
            logger.error("[Launch] ❌ Error during flow: \(error.localizedDescription)")
            logger.info("[Launch] Setting stub flag and showing stub")
            persistence.boltStrikeShouldShowStub = true
            return .showWeb(stubURL)
        }
    }
}
