//
//  VenuesListViewModelTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Testing
@testable import RedHotChiliDevs

@Suite("Venues List ViewModel Tests")
@MainActor
struct VenuesListViewModelTests {

    private func makeVenues() -> [Venue] {
        [
            Venue(id: 3, name: "Cobblequill Colosseum", sortId: 1),
            Venue(id: 4, name: "The Dive",              sortId: 2),
            Venue(id: 2, name: "Dreamland",             sortId: 3)
        ]
    }

    // MARK: - Tests
    @Test("Load venues success populates venues")
    func loadVenuesSuccessPopulatesVenues() async {
        
        let mock = MockNetworkService()
        mock.responses["/venues"] = makeVenues()

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = VenuesListViewModel(repository: repo)

        await viewModel.loadVenues()

        #expect(viewModel.venues.count == 3)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("Load venues sorted by sortId")
    func loadVenuesSortedBySortId() async {
        
        // Provide unsorted input
        let unsorted = [
            Venue(id: 2, name: "Dreamland",             sortId: 3),
            Venue(id: 3, name: "Cobblequill Colosseum", sortId: 1),
            Venue(id: 4, name: "The Dive",              sortId: 2)
        ]

        let mock = MockNetworkService()
        mock.responses["/venues"] = unsorted

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = VenuesListViewModel(repository: repo)

        await viewModel.loadVenues()

        #expect(viewModel.venues.map(\.sortId) == [1, 2, 3])
    }

    @Test("Load venues network failure sets error message")
    func loadVenuesNetworkFailureSetsErrorMessage() async {
        
        let mock = MockNetworkService()
        mock.errorToThrow = .invalidURL

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = VenuesListViewModel(repository: repo)

        await viewModel.loadVenues()

        #expect(viewModel.venues.isEmpty)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("Load venues caching calls network once")
    func loadVenuesCachingCallsNetworkOnce() async {
        
        let mock  = MockNetworkService()
        let cache = MockCacheService()
        mock.responses["/venues"] = makeVenues()

        let repo = VenueRepository(networkService: mock, cacheService: cache)
        let viewModel  = VenuesListViewModel(repository: repo)

        await viewModel.loadVenues()
        await viewModel.loadVenues()

        #expect(mock.requestedEndpoints.filter { $0 == "/venues" }.count == 1)
    }
}
