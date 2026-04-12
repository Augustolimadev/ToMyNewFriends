//
//  APIEndpointTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import XCTest
@testable import RedHotChiliDevs

final class APIEndpointTests: XCTestCase {

    func testArtistsPath() {
        XCTAssertEqual(APIEndpoint.artists.path, "/artists")
    }
    
    func testArtistPerformancesPath() {
        XCTAssertEqual(APIEndpoint.artistPerformances(id: 7).path, "/artists/7/performances")
    }

    func testVenuesPath() {
        XCTAssertEqual(APIEndpoint.venues.path, "/venues")
    }

    func testVenuePerformancesPath() {
        XCTAssertEqual(APIEndpoint.venuePerformances(id: 3).path, "/venues/3/performances")
    }

    func testArtistPerformancesWithDateRangeBuildsCorrectURL() {
        
        var components = DateComponents()
        components.year = 2026; components.month = 4; components.day = 12
        let from = Calendar.current.date(from: components)!

        components.day = 14
        let to = Calendar.current.date(from: components)!

        let endpoint = APIEndpoint.artistPerformances(id: 7, from: from, to: to)
        let url = endpoint.url!
        let urlString = url.absoluteString

        XCTAssertTrue(urlString.contains("from=2026-04-12"))
        XCTAssertTrue(urlString.contains("to=2026-04-25"))
    }

    func testVenuePerformancesWithFromOnlyOmitsToParam() {
        
        var components = DateComponents()
        components.year = 2026; components.month = 4; components.day = 12
        let from = Calendar.current.date(from: components)!

        let endpoint = APIEndpoint.venuePerformances(id: 2, from: from, to: nil)
        let url = endpoint.url!
        let urlString = url.absoluteString

        XCTAssertTrue(urlString.contains("from=2026-04-12"))
        XCTAssertFalse(urlString.contains("to="))
    }

    func testArtistsUrlHasCorrectBaseURL() {
        XCTAssertEqual(APIEndpoint.artists.url?.host(), "mybaseapi.com")
    }
}
