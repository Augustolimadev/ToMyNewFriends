//
//  ArtistsListViewModelTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Testing
@testable import RedHotChiliDevs

@Suite("Artists List ViewModel Tests")
@MainActor
struct ArtistsListViewModelTests {

    // MARK: - Helpers
    private func makeArtists() -> [Artist] {
        [
            Artist(id: 7, name: "Beat Illuminati",  genre: "Dance"),
            Artist(id: 3, name: "Diva Moon Rescue",  genre: "Pop"),
            Artist(id: 2, name: "High Noon Saloon",  genre: "Country")
        ]
    }

    // MARK: - Tests
    @Test("Load artists success populates artists")
    func loadArtistsSuccessPopulatesArtists() async throws {
        
        let mock = MockNetworkService()
        mock.responses["/artists"] = makeArtists()

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistsListViewModel(repository: repo)

        await viewModel.loadArtists()

        #expect(viewModel.artists.count == 3)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("Load artists sorted alphabetically")
    func loadArtistsSortedAlphabetically() async {
        
        let mock = MockNetworkService()
        mock.responses["/artists"] = makeArtists()

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistsListViewModel(repository: repo)

        await viewModel.loadArtists()

        #expect(viewModel.artists.map(\.name) == [
            "Beat Illuminati",
            "Diva Moon Rescue",
            "High Noon Saloon"
        ])
    }

    @Test("Load artists network failure sets error message")
    func loadArtistsNetworkFailureSetsErrorMessage() async {
        
        let mock = MockNetworkService()
        mock.errorToThrow = .statusCode(500)

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistsListViewModel(repository: repo)

        await viewModel.loadArtists()

        #expect(viewModel.artists.isEmpty)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("Load artists returns cached data")
    func loadArtistsReturnsCachedData() async {
        
        let mock  = MockNetworkService()
        let cache = MockCacheService()
        mock.responses["/artists"] = makeArtists()

        let repo = ArtistRepository(networkService: mock, cacheService: cache)
        let viewModel  = ArtistsListViewModel(repository: repo)

        await viewModel.loadArtists()
        await viewModel.loadArtists() // second call — should hit cache

        // Network should only have been called once
        #expect(mock.requestedEndpoints.filter { $0 == "/artists" }.count == 1)
    }

    @Test("Load artists isLoading transition")
    func loadArtistsIsLoadingTransition() async {
        
        let mock = MockNetworkService()
        mock.responses["/artists"] = makeArtists()

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistsListViewModel(repository: repo)

        #expect(viewModel.isLoading == false)
        await viewModel.loadArtists()
        #expect(viewModel.isLoading == false)
    }
}
