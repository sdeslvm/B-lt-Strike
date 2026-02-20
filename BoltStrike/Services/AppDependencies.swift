

import Foundation

struct BoltStrikeAppDependencies {
    // MARK: - Dependencies
    let persistenceService: BoltStrikePersistenceService
    let trackingService: BoltStrikeTrackingService
    let remoteConfigService: BoltStrikeFirebaseRealtimeService
    let backendClient: BoltStrikeBackendClient
    let linkAssemblyService: BoltStrikeLinkAssemblyService
    let launchService: BoltStrikeLaunchService
    let webViewCoordinator: BoltStrikeWebViewCoordinator

    init() {
        let persistenceService = BoltStrikePersistenceService()
        let cookieStore = BoltStrikeCookieStoreManager.boltStrikeShared
        let pushStore = BoltStrikePushTokenStore.boltStrikeShared

        #if targetEnvironment(simulator)
        persistenceService.boltStrikeClear()
        #endif

        self.persistenceService = persistenceService
        self.trackingService = BoltStrikeTrackingService(persistence: persistenceService,
                                               pushTokenStore: pushStore)
        self.remoteConfigService = BoltStrikeFirebaseRealtimeService()
        self.backendClient = BoltStrikeBackendClient()
        self.linkAssemblyService = BoltStrikeLinkAssemblyService()
        self.launchService = BoltStrikeLaunchService(
            persistence: persistenceService,
            trackingService: trackingService,
            remoteConfigService: remoteConfigService,
            backendClient: backendClient,
            linkAssemblyService: linkAssemblyService,
            cookieStore: cookieStore
        )
        self.webViewCoordinator = BoltStrikeWebViewCoordinator()
    }
}
