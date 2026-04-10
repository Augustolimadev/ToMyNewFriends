//
//  CacheServiceTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import XCTest
@testable import RedHotChiliDevs

final class CacheServiceTests: XCTestCase {

    func testSetAndGetReturnsStoredValue() {
        
        let cache = CacheService(ttl: 60)
        let artists = [Artist(id: 1, name: "Test Artist", genre: "Rock")]

        cache.set(artists, forKey: "artists")
        let result = cache.get([Artist].self, forKey: "artists")

        XCTAssertEqual(result?.first?.name, "Test Artist")
    }

    func testGetAfterExpiryReturnsNil() {
        
        let cache = CacheService(ttl: 0) // zero TTL → immediately expired
        let artist = Artist(id: 1, name: "Test", genre: "Pop")

        cache.set(artist, forKey: "artist")
        // Even a tiny sleep would be flaky; use ttl: 0 to guarantee expiry
        Thread.sleep(forTimeInterval: 0.01)

        let result = cache.get(Artist.self, forKey: "artist")
        XCTAssertNil(result)
    }

    func testRemoveClearsKey() {
        
        let cache = CacheService(ttl: 60)
        cache.set(Venue(id: 1, name: "Test", sortId: 1), forKey: "venue")
        cache.remove(forKey: "venue")

        XCTAssertNil(cache.get(Venue.self, forKey: "venue"))
    }

    func testClearAllRemovesEverything() {
        
        let cache = CacheService(ttl: 60)
        cache.set(Artist(id: 1, name: "A", genre: "X"), forKey: "a")
        cache.set(Artist(id: 2, name: "B", genre: "Y"), forKey: "b")

        cache.clearAll()

        XCTAssertNil(cache.get(Artist.self, forKey: "a"))
        XCTAssertNil(cache.get(Artist.self, forKey: "b"))
    }

    func testMockCacheBehavesLikeRealCache() {
        
        let cache = MockCacheService()
        let venue = Venue(id: 3, name: "Cobblequill Colosseum", sortId: 1)

        cache.set(venue, forKey: "venue_3")
        let result = cache.get(Venue.self, forKey: "venue_3")

        XCTAssertEqual(result?.name, "Cobblequill Colosseum")
    }
}
