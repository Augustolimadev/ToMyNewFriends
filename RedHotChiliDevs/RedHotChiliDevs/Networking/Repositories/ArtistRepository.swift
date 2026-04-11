//
//  ArtistRepository.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

final class ArtistRepository: ArtistRepositoryProtocol {

    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol

    // MARK: - Cache Keys
    private let artistsKey = "artists_all"
    private func performancesKey(_ id: Int, from: Date?, to: Date?) -> String {
        "artist_perf_\(id)_\(from?.timeIntervalSince1970 ?? 0)_\(to?.timeIntervalSince1970 ?? 0)"
    }

    // MARK: - Init
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    // MARK: - ArtistRepositoryProtocol
    func fetchArtists() async throws -> [Artist] {
        
        if let cached = cacheService.get([Artist].self, forKey: artistsKey) {
            return cached
        }
        let artists = try await networkService.fetch([Artist].self, from: .artists)
        let sorted = artists.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        cacheService.set(sorted, forKey: artistsKey)
        return sorted
    }
    
    func fetchPerformances(for artistId: Int, from: Date?, to: Date?) async throws -> [ArtistPerformance] {
        
        let key = performancesKey(artistId, from: from, to: to)
        if let cached = cacheService.get([ArtistPerformance].self, forKey: key) {
            return cached
        }
        let performances = try await networkService.fetch([ArtistPerformance].self,
                                                          from: .artistPerformances(id: artistId, from: from, to: to))
        let sorted = performances.sorted { $0.date < $1.date }
        cacheService.set(sorted, forKey: key)
        return sorted
    }
}
