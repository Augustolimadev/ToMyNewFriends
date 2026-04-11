//
//  VenueRepositoryProtocol.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Foundation

protocol VenueRepositoryProtocol: Sendable {
    
    /// Returns all venues sorted by their `sortId`.
    func fetchVenues() async throws -> [Venue]
    
    /// Returns performances for the given venue within an optional date range.
    /// Each `VenuePerformance` embeds the full `Artist` object.
    func fetchPerformances(for venueId: Int, from: Date?, to: Date?) async throws -> [VenuePerformance]
}
