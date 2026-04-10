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
}
