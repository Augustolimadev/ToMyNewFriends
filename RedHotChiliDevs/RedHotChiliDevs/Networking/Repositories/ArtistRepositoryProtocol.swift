//
//  ArtistRepositoryProtocol.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

protocol ArtistRepositoryProtocol: Sendable {
    
    /// Returns all artists sorted alphabetically by name.
    func fetchArtists() async throws -> [Artist]

    /// Returns performances for the given artist within an optional date range.
    /// Each `ArtistPerformance` embeds the full `Venue` object.
    func fetchPerformances(for artistId: Int, from: Date?, to: Date?) async throws -> [ArtistPerformance]
}
