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
}
