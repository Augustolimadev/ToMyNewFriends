//
//  ArtistsListViewModelTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import XCTest
@testable import RedHotChiliDevs

@MainActor
final class ArtistsListViewModelTests: XCTestCase {

    // MARK: - Helpers
    private func makeArtists() -> [Artist] {
        [
            Artist(id: 7, name: "Beat Illuminati",  genre: "Dance"),
            Artist(id: 3, name: "Diva Moon Rescue",  genre: "Pop"),
            Artist(id: 2, name: "High Noon Saloon",  genre: "Country")
        ]
    }

    // MARK: - Tests
    func testLoadArtistsSuccessPopulatesArtists() async throws {
        
        let mock = MockNetworkService()
        mock.responses["/artists"] = makeArtists()

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let model  = ArtistsListViewModel(repository: repo)

        await model.loadArtists()

        XCTAssertEqual(model.artists.count, 3)
        XCTAssertNil(model.errorMessage)
        XCTAssertFalse(model.isLoading)
    }

    func testLoadArtistsSortedAlphabetically() async {
        
        let mock = MockNetworkService()
        mock.responses["/artists"] = makeArtists()

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let model  = ArtistsListViewModel(repository: repo)

        await model.loadArtists()

        XCTAssertEqual(model.artists.map(\.name), [
            "Beat Illuminati",
            "Diva Moon Rescue",
            "High Noon Saloon"
        ])
    }

    func testLoadArtistsNetworkFailureSetsErrorMessage() async {
        
        let mock = MockNetworkService()
        mock.errorToThrow = .statusCode(500)

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let model  = ArtistsListViewModel(repository: repo)

        await model.loadArtists()

        XCTAssertTrue(model.artists.isEmpty)
        XCTAssertNotNil(model.errorMessage)
        XCTAssertFalse(model.isLoading)
    }

    func testLoadArtistsReturnsCachedData() async {
        
        let mock  = MockNetworkService()
        let cache = MockCacheService()
        mock.responses["/artists"] = makeArtists()

        let repo = ArtistRepository(networkService: mock, cacheService: cache)
        let model  = ArtistsListViewModel(repository: repo)

        await model.loadArtists()
        await model.loadArtists() // second call — should hit cache

        // Network should only have been called once
        XCTAssertEqual(mock.requestedEndpoints.filter { $0 == "/artists" }.count, 1)
    }

    func testLoadArtistsIsLoadingTransition() async {
        
        let mock = MockNetworkService()
        mock.responses["/artists"] = makeArtists()

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let model  = ArtistsListViewModel(repository: repo)

        XCTAssertFalse(model.isLoading)
        await model.loadArtists()
        XCTAssertFalse(model.isLoading)
    }
}
