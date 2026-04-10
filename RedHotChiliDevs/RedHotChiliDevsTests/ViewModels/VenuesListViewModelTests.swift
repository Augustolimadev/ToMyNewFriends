//
//  VenuesListViewModelTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import XCTest
@testable import RedHotChiliDevs

@MainActor
final class VenuesListViewModelTests: XCTestCase {

    private func makeVenues() -> [Venue] {
        [
            Venue(id: 3, name: "Cobblequill Colosseum", sortId: 1),
            Venue(id: 4, name: "The Dive",              sortId: 2),
            Venue(id: 2, name: "Dreamland",             sortId: 3)
        ]
    }

    // MARK: - Tests
    func testLoadVenuesSuccessPopulatesVenues() async {
        
        let mock = MockNetworkService()
        mock.responses["/venues"] = makeVenues()

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let model  = VenuesListViewModel(repository: repo)

        await model.loadVenues()

        XCTAssertEqual(model.venues.count, 3)
        XCTAssertNil(model.errorMessage)
        XCTAssertFalse(model.isLoading)
    }

    func testLoadVenuesSortedBySortId() async {
        
        // Provide unsorted input
        let unsorted = [
            Venue(id: 2, name: "Dreamland",             sortId: 3),
            Venue(id: 3, name: "Cobblequill Colosseum", sortId: 1),
            Venue(id: 4, name: "The Dive",              sortId: 2)
        ]

        let mock = MockNetworkService()
        mock.responses["/venues"] = unsorted

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let model  = VenuesListViewModel(repository: repo)

        await model.loadVenues()

        XCTAssertEqual(model.venues.map(\.sortId), [1, 2, 3])
    }

    func testLoadVenuesNetworkFailureSetsErrorMessage() async {
        
        let mock = MockNetworkService()
        mock.errorToThrow = .invalidURL

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let model  = VenuesListViewModel(repository: repo)

        await model.loadVenues()

        XCTAssertTrue(model.venues.isEmpty)
        XCTAssertNotNil(model.errorMessage)
        XCTAssertFalse(model.isLoading)
    }

    func testLoadVenuesCachingCallsNetworkOnce() async {
        
        let mock  = MockNetworkService()
        let cache = MockCacheService()
        mock.responses["/venues"] = makeVenues()

        let repo = VenueRepository(networkService: mock, cacheService: cache)
        let model  = VenuesListViewModel(repository: repo)

        await model.loadVenues()
        await model.loadVenues()

        XCTAssertEqual(mock.requestedEndpoints.filter { $0 == "/venues" }.count, 1)
    }
}
