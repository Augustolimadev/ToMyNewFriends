//
//  VenueRepository.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Foundation

final class VenueRepository: VenueRepositoryProtocol {

    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol

    // MARK: - Cache Key
    private let venuesKey = "venues_all"
    private func performancesKey(_ id: Int, from: Date?, to: Date?) -> String {
        "venue_perf_\(id)_\(from?.timeIntervalSince1970 ?? 0)_\(to?.timeIntervalSince1970 ?? 0)"
    }

    // MARK: - Init
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    // MARK: - VenueRepositoryProtocol
    func fetchVenues() async throws -> [Venue] {
        
        if let cached = cacheService.get([Venue].self, forKey: venuesKey) {
            return cached
        }
        let venues = try await networkService.fetch([Venue].self, from: .venues)
        let sorted = venues.sorted { $0.sortId < $1.sortId }
        cacheService.set(sorted, forKey: venuesKey)
        return sorted
    }
    
    func fetchPerformances(for venueId: Int, from: Date?, to: Date?) async throws -> [VenuePerformance] {
        
        let key = performancesKey(venueId, from: from, to: to)
        if let cached = cacheService.get([VenuePerformance].self, forKey: key) {
            return cached
        }
        let performances = try await networkService.fetch(
            [VenuePerformance].self,
            from: .venuePerformances(id: venueId, from: from, to: to)
        )
        let sorted = performances.sorted { $0.date < $1.date }
        cacheService.set(sorted, forKey: key)
        return sorted
    }
}
