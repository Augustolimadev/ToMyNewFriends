//
//  RedHotChiliDevsApp.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

@main
struct RedHotChiliDevsApp: App {
    
    /// `NetworkService` and `CacheService` instance.
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.artistRepository, container.artistRepository)
                .environment(\.venueRepository, container.venueRepository)
        }
    }
}
