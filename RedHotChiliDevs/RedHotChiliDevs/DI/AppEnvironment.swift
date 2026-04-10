//
//  AppEnvironment.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

// MARK: - Artist Repository Environment Key
private struct ArtistRepositoryKey: EnvironmentKey {
    static let defaultValue: ArtistRepositoryProtocol = ArtistRepository(networkService: NetworkService(),
                                                                         cacheService: CacheService())
}

extension EnvironmentValues {
    
    var artistRepository: ArtistRepositoryProtocol {
        get { self[ArtistRepositoryKey.self] }
        set { self[ArtistRepositoryKey.self] = newValue }
    }
}

// MARK: - App Container (convenience for App entry point)

/// Centralises dependency construction so a single pair of
/// `NetworkService` / `CacheService` instances is shared.
struct AppContainer {
    
    let artistRepository: ArtistRepositoryProtocol

    init(networkService: NetworkServiceProtocol = NetworkService(),
         cacheService: CacheServiceProtocol = CacheService()) {
        
        artistRepository = ArtistRepository(networkService: networkService,
                                            cacheService: cacheService)
    }
}
