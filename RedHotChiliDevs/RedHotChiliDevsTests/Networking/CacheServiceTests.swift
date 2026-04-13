//
//  CacheServiceTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Testing
@testable import RedHotChiliDevs

@Suite("Cache Service Tests")
struct CacheServiceTests {

    @Test("Set and get returns stored value")
    func setAndGetReturnsStoredValue() {
        
        let cache = CacheService(ttl: 60)
        let artists = [Artist(id: 1, name: "Test Artist", genre: "Rock")]

        cache.set(artists, forKey: "artists")
        let result = cache.get([Artist].self, forKey: "artists")

        #expect(result?.first?.name == "Test Artist")
    }

    @Test("Get after expiry returns nil")
    func getAfterExpiryReturnsNil() async throws {
        
        let cache = await CacheService(ttl: 0.01) // 10ms TTL
        let artist = Artist(id: 1, name: "Test", genre: "Pop")

        await cache.set(artist, forKey: "artist")
        
        // Wait for expiry
        try await Task.sleep(for: .milliseconds(20))

        let result = await cache.get(Artist.self, forKey: "artist")
        #expect(result == nil)
    }

    @Test("Remove clears key")
    func removeClearsKey() {
        
        let cache = CacheService(ttl: 60)
        cache.set(Venue(id: 1, name: "Test", sortId: 1), forKey: "venue")
        cache.remove(forKey: "venue")

        #expect(cache.get(Venue.self, forKey: "venue") == nil)
    }

    @Test("Clear all removes everything")
    func clearAllRemovesEverything() {
        
        let cache = CacheService(ttl: 60)
        cache.set(Artist(id: 1, name: "A", genre: "X"), forKey: "a")
        cache.set(Artist(id: 2, name: "B", genre: "Y"), forKey: "b")

        cache.clearAll()

        #expect(cache.get(Artist.self, forKey: "a") == nil)
        #expect(cache.get(Artist.self, forKey: "b") == nil)
    }

    @Test("Mock cache behaves like real cache")
    func mockCacheBehavesLikeRealCache() {
        
        let cache = MockCacheService()
        let venue = Venue(id: 3, name: "Cobblequill Colosseum", sortId: 1)

        cache.set(venue, forKey: "venue_3")
        let result = cache.get(Venue.self, forKey: "venue_3")

        #expect(result?.name == "Cobblequill Colosseum")
    }
    
    @Test("Cache handles multiple types")
    func cacheHandlesMultipleTypes() {
        
        let cache = CacheService(ttl: 60)
        
        let artist = Artist(id: 1, name: "Artist", genre: "Rock")
        let venue = Venue(id: 1, name: "Venue", sortId: 1)
        
        cache.set(artist, forKey: "artist")
        cache.set(venue, forKey: "venue")
        
        let retrievedArtist = cache.get(Artist.self, forKey: "artist")
        let retrievedVenue = cache.get(Venue.self, forKey: "venue")
        
        #expect(retrievedArtist?.name == "Artist")
        #expect(retrievedVenue?.name == "Venue")
    }
    
    @Test("Cache does not return wrong type")
    func cacheDoesNotReturnWrongType() {
        
        let cache = CacheService(ttl: 60)
        let artist = Artist(id: 1, name: "Artist", genre: "Rock")
        
        cache.set(artist, forKey: "data")
        
        // Try to get as Venue (wrong type)
        let wrongType = cache.get(Venue.self, forKey: "data")
        #expect(wrongType == nil)
    }
    
    @Test("Cache preserves array data")
    func cachePreservesArrayData() {
        
        let cache = CacheService(ttl: 60)
        let artists = [
            Artist(id: 1, name: "Artist 1", genre: "Rock"),
            Artist(id: 2, name: "Artist 2", genre: "Pop"),
            Artist(id: 3, name: "Artist 3", genre: "Jazz")
        ]
        
        cache.set(artists, forKey: "artists")
        let result = cache.get([Artist].self, forKey: "artists")
        
        #expect(result?.count == 3)
        #expect(result?[0].name == "Artist 1")
        #expect(result?[1].name == "Artist 2")
        #expect(result?[2].name == "Artist 3")
    }
}
