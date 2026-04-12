//
//  Performance.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Foundation

/// Performance with embedded Venue — returned from /artists/{id}/performances
struct ArtistPerformance: Identifiable, Hashable, Sendable {
    let id: Int
    let date: Date
    let venue: Venue
}

// MARK: - Codable Conformance
extension ArtistPerformance: Codable {
    
    // Explicitly nonisolated conformance
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.date = try container.decodeAPIDate(forKey: .date)
        self.venue = try container.decode(Venue.self, forKey: .venue)
    }
    
    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeAPIDate(date, forKey: .date)
        try container.encode(venue, forKey: .venue)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, artistId, date, venue
    }
}

/// Performance with embedded Artist — returned from /venues/{id}/performances
struct VenuePerformance: Identifiable, Hashable, Sendable {
    let id: Int
    let date: Date
    let artist: Artist
}

// MARK: - Codable Conformance
extension VenuePerformance: Codable {
    
    // Explicitly nonisolated conformance
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.date = try container.decodeAPIDate(forKey: .date)
        self.artist = try container.decode(Artist.self, forKey: .artist)
    }
    
    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeAPIDate(date, forKey: .date)
        try container.encode(artist, forKey: .artist)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, date, artist
    }
}
