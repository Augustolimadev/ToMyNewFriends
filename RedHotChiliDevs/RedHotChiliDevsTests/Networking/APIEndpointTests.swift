//
//  APIEndpointTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import XCTest
@testable import RedHotChiliDevs

final class APIEndpointTests: XCTestCase {

    func test_artists_path() {
        XCTAssertEqual(APIEndpoint.artists.path, "/artists")
    }

    func test_venues_path() {
        XCTAssertEqual(APIEndpoint.venues.path, "/venues")
    }
}
