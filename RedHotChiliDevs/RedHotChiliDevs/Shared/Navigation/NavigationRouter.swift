//
//  NavigationRouter.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import SwiftUI
import Observation

// MARK: - Route Definition
/// All possible navigation destinations in the app
enum Route: Hashable {
    case artistDetail(Artist)
    case venueDetail(Venue)
}

// MARK: - Navigation Router
/// Centralized navigation state management
@Observable
final class NavigationRouter {
    
    /// Navigation path for the current stack
    var path: NavigationPath = NavigationPath()
    
    /// Navigate to a specific route
    func navigate(to route: Route) {
        path.append(route)
    }
    
    /// Navigate back one level
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Navigate back to root
    func navigateToRoot() {
        path = NavigationPath()
    }
    
    /// Pop to a specific depth
    func popToDepth(_ depth: Int) {
        
        let currentCount = path.count
        guard depth < currentCount else { return }
        
        let itemsToRemove = currentCount - depth
        path.removeLast(itemsToRemove)
    }
}

// MARK: - Environment Key
private struct NavigationRouterKey: EnvironmentKey {
    static let defaultValue = NavigationRouter()
}

extension EnvironmentValues {
    var navigationRouter: NavigationRouter {
        get { self[NavigationRouterKey.self] }
        set { self[NavigationRouterKey.self] = newValue }
    }
}

// MARK: - Navigation Destination Builder
extension View {
    
    /// Apply all navigation destinations for the app
    @ViewBuilder
    func withAppNavigationDestinations() -> some View {
        self
            .navigationDestination(for: Route.self) { route in
                route.destination
            }
    }
}

// MARK: - Route Destination Views
private extension Route {
    
    @ViewBuilder
    var destination: some View {
        
        switch self {
        case .artistDetail(let artist):
            ArtistDetailView(artist: artist)
            
        case .venueDetail(let venue):
            VenueDetailView(venue: venue)
        }
    }
}
