//
//  VenueRepository.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Foundation

/// Repository for managing venue data with caching support.
///
/// This repository implements the Repository Pattern, providing a clean abstraction
/// over network and cache data sources. It handles:
/// - Fetching venues from the API
/// - Fetching performances for a specific venue
/// - Automatic caching of responses
/// - Sorting of results
///
/// ## Architecture
/// ```
/// ViewModel → VenueRepository → [NetworkService, CacheService]
/// ```
///
/// ## Usage
/// ```swift
/// let repository = VenueRepository(
///     networkService: NetworkService(),
///     cacheService: CacheService()
/// )
///
/// // Fetch all venues
/// let venues = try await repository.fetchVenues()
///
/// // Fetch performances for a venue
/// let performances = try await repository.fetchPerformances(
///     for: 3,
///     from: Date(),
///     to: Date().addingTimeInterval(14 * 24 * 3600)
/// )
/// ```
final class VenueRepository: VenueRepositoryProtocol {

    // MARK: - Properties
    
    /// Network service for API requests
    private let networkService: NetworkServiceProtocol
    
    /// Cache service for storing responses
    private let cacheService: CacheServiceProtocol

    // MARK: - Cache Keys
    
    /// Cache key for all venues list
    private let venuesKey = "venues_all"
    
    /// Generates a unique cache key for venue performances
    /// - Parameters:
    ///   - id: The venue ID
    ///   - from: Start date for performances (optional)
    ///   - to: End date for performances (optional)
    /// - Returns: A unique cache key string
    private func performancesKey(_ id: Int, from: Date?, to: Date?) -> String {
        "venue_perf_\(id)_\(from?.timeIntervalSince1970 ?? 0)_\(to?.timeIntervalSince1970 ?? 0)"
    }

    // MARK: - Initialization
    
    /// Creates a new venue repository
    /// - Parameters:
    ///   - networkService: Service for making network requests
    ///   - cacheService: Service for caching responses
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    // MARK: - VenueRepositoryProtocol
    
    /// Fetches all venues, sorted by their sort ID.
    ///
    /// This method implements a cache-first strategy:
    /// 1. Check cache for existing data
    /// 2. If cache hit, return cached data immediately
    /// 3. If cache miss, fetch from network
    /// 4. Sort results by sortId
    /// 5. Store in cache for future requests
    /// 6. Return sorted results
    ///
    /// - Returns: Array of venues sorted by sortId
    /// - Throws: `NetworkError` if the network request fails
    ///
    /// ## Example
    /// ```swift
    /// let venues = try await repository.fetchVenues()
    /// // Returns: [Venue(sortId: 1), Venue(sortId: 2), ...]
    /// ```
    func fetchVenues() async throws -> [Venue] {
        
        // Try to get from cache first
        if let cached = cacheService.get([Venue].self, forKey: venuesKey) {
            return cached
        }
        
        // Fetch from network
        let venues = try await networkService.fetch([Venue].self, from: .venues)
        
        // Sort by sortId (ascending)
        let sorted = venues.sorted { $0.sortId < $1.sortId }
        
        // Store in cache
        cacheService.set(sorted, forKey: venuesKey)
        
        return sorted
    }
    
    /// Fetches performances for a specific venue within a date range.
    ///
    /// This method implements a cache-first strategy with date-range based cache keys:
    /// 1. Generate unique cache key based on venue ID and date range
    /// 2. Check cache for existing data
    /// 3. If cache hit, return cached data immediately
    /// 4. If cache miss, fetch from network
    /// 5. Sort results chronologically by date
    /// 6. Store in cache for future requests
    /// 7. Return sorted results
    ///
    /// - Parameters:
    ///   - venueId: The ID of the venue
    ///   - from: Start date for the performance range (optional)
    ///   - to: End date for the performance range (optional)
    /// - Returns: Array of performances sorted chronologically by date
    /// - Throws: `NetworkError` if the network request fails
    ///
    /// ## Example
    /// ```swift
    /// let from = Date()
    /// let to = Date().addingTimeInterval(14 * 24 * 3600) // 14 days
    /// let performances = try await repository.fetchPerformances(
    ///     for: 3,
    ///     from: from,
    ///     to: to
    /// )
    /// // Returns performances sorted by date
    /// ```
    func fetchPerformances(for venueId: Int, from: Date?, to: Date?) async throws -> [VenuePerformance] {
        
        // Generate cache key based on parameters
        let key = performancesKey(venueId, from: from, to: to)
        
        // Try to get from cache first
        if let cached = cacheService.get([VenuePerformance].self, forKey: key) {
            return cached
        }
        
        // Fetch from network
        let performances = try await networkService.fetch(
            [VenuePerformance].self,
            from: .venuePerformances(id: venueId, from: from, to: to)
        )
        
        // Sort chronologically by date
        let sorted = performances.sorted { $0.date < $1.date }
        
        // Store in cache
        cacheService.set(sorted, forKey: key)
        
        return sorted
    }
}
