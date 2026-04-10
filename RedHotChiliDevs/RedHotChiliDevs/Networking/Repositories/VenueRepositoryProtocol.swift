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
}
