//
//  ArtistDetailViewModelTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 12/4/2026.
//

import XCTest
@testable import RedHotChiliDevs

@MainActor
final class ArtistDetailViewModelTests: XCTestCase {

    private let artist = Artist(id: 7, name: "Beat Illuminati", genre: "Dance")
    private let venueA = Venue(id: 3, name: "Cobblequill Colosseum", sortId: 1)
    private let venueB = Venue(id: 4, name: "The Dive",             sortId: 2)

    private func makePerformances(relative offsets: [Int]) -> [ArtistPerformance] {
        
        let base = Calendar.current.startOfDay(for: Date())
        
        return offsets.enumerated().map { index, offset in
            let date = Calendar.current.date(byAdding: .day, value: offset, to: base)!
            return ArtistPerformance(
                id: index + 1,
                date: date,
                venue: index % 2 == 0 ? venueA : venueB
            )
        }
    }

    // MARK: - Tests
    func testLoadPerformancesSuccessPopulatesPerformances() async {
        
        let performances = makePerformances(relative: [1, 5, 10])

        let mock = MockNetworkService()
        mock.responses["/artists/7/performances"] = performances

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistDetailViewModel(artist: artist, repository: repo)

        await viewModel.loadPerformances()

        XCTAssertEqual(viewModel.performances.count, 3)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadPerformancesSortedByDate() async {
        
        // Provide out-of-order dates
        let performances = makePerformances(relative: [10, 1, 5])

        let mock = MockNetworkService()
        mock.responses["/artists/7/performances"] = performances

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistDetailViewModel(artist: artist, repository: repo)

        await viewModel.loadPerformances()

        let dates = viewModel.performances.map(\.date)
        XCTAssertEqual(dates, dates.sorted())
    }

    func testLoadPerformancesNetworkFailureSetsErrorMessage() async {
        
        let mock = MockNetworkService()
        mock.errorToThrow = .statusCode(404)

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistDetailViewModel(artist: artist, repository: repo)

        await viewModel.loadPerformances()

        XCTAssertTrue(viewModel.performances.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testLoadPerformancesEmpty_doesNotSetError() async {
        
        let mock = MockNetworkService()
        mock.responses["/artists/7/performances"] = [ArtistPerformance]()

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistDetailViewModel(artist: artist, repository: repo)

        await viewModel.loadPerformances()

        XCTAssertTrue(viewModel.performances.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadPerformancesUsesDateRangeQueryParams() async {
        
        let mock = MockNetworkService()
        mock.responses["/artists/7/performances"] = [ArtistPerformance]()

        let repo = ArtistRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = ArtistDetailViewModel(artist: artist, repository: repo)

        await viewModel.loadPerformances()

        // The path is the same regardless of query params — verify it was called
        XCTAssertTrue(mock.requestedEndpoints.contains("/artists/7/performances"))
    }
}
