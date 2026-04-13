//
//  ArtistRepository.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

/// Repository for managing artist data with caching support.
///
/// This repository implements the Repository Pattern, providing a clean abstraction
/// over network and cache data sources. It handles:
/// - Fetching artists from the API
/// - Fetching performances for a specific artist
/// - Automatic caching of responses
/// - Sorting of results
///
/// ## Architecture
/// ```
/// ViewModel → ArtistRepository → [NetworkService, CacheService]
/// ```
///
/// ## Usage
/// ```swift
/// let repository = ArtistRepository(
///     networkService: NetworkService(),
///     cacheService: CacheService()
/// )
///
/// // Fetch all artists
/// let artists = try await repository.fetchArtists()
///
/// // Fetch performances for an artist
/// let performances = try await repository.fetchPerformances(
///     for: 7,
///     from: Date(),
///     to: Date().addingTimeInterval(14 * 24 * 3600)
/// )
/// ```
final class ArtistRepository: ArtistRepositoryProtocol {

    // MARK: - Properties
    
    /// Network service for API requests
    private let networkService: NetworkServiceProtocol
    
    /// Cache service for storing responses
    private let cacheService: CacheServiceProtocol

    // MARK: - Cache Keys
    
    /// Cache key for all artists list
    private let artistsKey = "artists_all"
    
    /// Generates a unique cache key for artist performances
    /// - Parameters:
    ///   - id: The artist ID
    ///   - from: Start date for performances (optional)
    ///   - to: End date for performances (optional)
    /// - Returns: A unique cache key string
    private func performancesKey(_ id: Int, from: Date?, to: Date?) -> String {
        "artist_perf_\(id)_\(from?.timeIntervalSince1970 ?? 0)_\(to?.timeIntervalSince1970 ?? 0)"
    }

    // MARK: - Initialization
    
    /// Creates a new artist repository
    /// - Parameters:
    ///   - networkService: Service for making network requests
    ///   - cacheService: Service for caching responses
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    // MARK: - ArtistRepositoryProtocol
    
    /// Fetches all artists, sorted alphabetically by name.
    ///
    /// This method implements a cache-first strategy:
    /// 1. Check cache for existing data
    /// 2. If cache hit, return cached data immediately
    /// 3. If cache miss, fetch from network
    /// 4. Sort results alphabetically
    /// 5. Store in cache for future requests
    /// 6. Return sorted results
    ///
    /// - Returns: Array of artists sorted alphabetically by name
    /// - Throws: `NetworkError` if the network request fails
    ///
    /// ## Example
    /// ```swift
    /// let artists = try await repository.fetchArtists()
    /// // Returns: [Artist(name: "Beat Illuminati"), Artist(name: "Diva Moon Rescue"), ...]
    /// ```
    func fetchArtists() async throws -> [Artist] {
        
        // Try to get from cache first
        if let cached = cacheService.get([Artist].self, forKey: artistsKey) {
            return cached
        }
        
        // Fetch from network
        let artists = try await networkService.fetch([Artist].self, from: .artists)
        
        // Sort alphabetically (locale-aware)
        let sorted = artists.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        
        // Store in cache
        cacheService.set(sorted, forKey: artistsKey)
        
        return sorted
    }
    
    /// Fetches performances for a specific artist within a date range.
    ///
    /// This method implements a cache-first strategy with date-range based cache keys:
    /// 1. Generate unique cache key based on artist ID and date range
    /// 2. Check cache for existing data
    /// 3. If cache hit, return cached data immediately
    /// 4. If cache miss, fetch from network
    /// 5. Sort results chronologically by date
    /// 6. Store in cache for future requests
    /// 7. Return sorted results
    ///
    /// - Parameters:
    ///   - artistId: The ID of the artist
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
    ///     for: 7,
    ///     from: from,
    ///     to: to
    /// )
    /// // Returns performances sorted by date
    /// ```
    func fetchPerformances(for artistId: Int, from: Date?, to: Date?) async throws -> [ArtistPerformance] {
        
        // Generate cache key based on parameters
        let key = performancesKey(artistId, from: from, to: to)
        
        // Try to get from cache first
        if let cached = cacheService.get([ArtistPerformance].self, forKey: key) {
            return cached
        }
        
        // Fetch from network
        let performances = try await networkService.fetch(
            [ArtistPerformance].self,
            from: .artistPerformances(id: artistId, from: from, to: to)
        )
        
        // Sort chronologically by date
        let sorted = performances.sorted { $0.date < $1.date }
        
        // Store in cache
        cacheService.set(sorted, forKey: key)
        
        return sorted
    }
}
