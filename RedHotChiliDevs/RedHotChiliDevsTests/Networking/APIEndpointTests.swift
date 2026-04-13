//
//  APIEndpointTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Testing
import Foundation
@testable import RedHotChiliDevs

@Suite("API Endpoint Tests")
struct APIEndpointTests {

    @Test("Artists path is correct")
    func artistsPath() {
        #expect(APIEndpoint.artists.path == "/artists")
    }
    
    @Test("Artist performances path is correct")
    func artistPerformancesPath() {
        #expect(APIEndpoint.artistPerformances(id: 7).path == "/artists/7/performances")
    }

    @Test("Venues path is correct")
    func venuesPath() {
        #expect(APIEndpoint.venues.path == "/venues")
    }

    @Test("Venue performances path is correct")
    func venuePerformancesPath() {
        #expect(APIEndpoint.venuePerformances(id: 3).path == "/venues/3/performances")
    }

    @Test("Artist performances with date range builds correct URL")
    func artistPerformancesWithDateRangeBuildsCorrectURL() {
        
        var components = DateComponents()
        components.year = 2026; components.month = 4; components.day = 12
        let from = Calendar.current.date(from: components)!

        components.day = 25
        let to = Calendar.current.date(from: components)!

        let endpoint = APIEndpoint.artistPerformances(id: 7, from: from, to: to)
        let url = endpoint.url!
        let urlString = url.absoluteString

        #expect(urlString.contains("from=2026-04-12"))
        #expect(urlString.contains("to=2026-04-25"))
    }

    @Test("Venue performances with from only omits to parameter")
    func venuePerformancesWithFromOnlyOmitsToParam() {
        
        var components = DateComponents()
        components.year = 2026; components.month = 4; components.day = 12
        let from = Calendar.current.date(from: components)!

        let endpoint = APIEndpoint.venuePerformances(id: 2, from: from, to: nil)
        let url = endpoint.url!
        let urlString = url.absoluteString

        #expect(urlString.contains("from=2026-04-12"))
        #expect(!urlString.contains("to="))
    }

    @Test("Artists URL has correct base URL")
    func artistsUrlHasCorrectBaseURL() {
        #expect(APIEndpoint.artists.url?.host() == "api.leapmobileinterview.com")
    }
}
