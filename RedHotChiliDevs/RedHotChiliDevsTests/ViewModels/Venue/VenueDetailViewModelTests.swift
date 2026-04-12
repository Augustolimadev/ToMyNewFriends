//
//  VenueDetailViewModelTests.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 12/4/2026.
//

import XCTest
@testable import RedHotChiliDevs

@MainActor
final class VenueDetailViewModelTests: XCTestCase {

    private let venue   = Venue(id: 3, name: "Cobblequill Colosseum", sortId: 1)
    private let artistA = Artist(id: 7, name: "Beat Illuminati",  genre: "Dance")
    private let artistB = Artist(id: 3, name: "Diva Moon Rescue",  genre: "Pop")

    private func makePerformances(relative offsets: [Int]) -> [VenuePerformance] {
        
        let base = Calendar.current.startOfDay(for: Date())
        return offsets.enumerated().map { index, offset in
            let date = Calendar.current.date(byAdding: .day, value: offset, to: base)!
            return VenuePerformance(
                id: index + 1,
                date: date,
                artist: index % 2 == 0 ? artistA : artistB
            )
        }
    }

    // MARK: - Tests
    func testLoadPerformancesSuccessPopulatesPerformances() async {
        
        let performances = makePerformances(relative: [2, 7, 12])

        let mock = MockNetworkService()
        mock.responses["/venues/3/performances"] = performances

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = VenueDetailViewModel(venue: venue, repository: repo)

        await viewModel.loadPerformances()

        XCTAssertEqual(viewModel.performances.count, 3)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadPerformancesSortedByDate() async {
        
        let performances = makePerformances(relative: [12, 2, 7])

        let mock = MockNetworkService()
        mock.responses["/venues/3/performances"] = performances

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = VenueDetailViewModel(venue: venue, repository: repo)

        await viewModel.loadPerformances()

        let dates = viewModel.performances.map(\.date)
        XCTAssertEqual(dates, dates.sorted())
    }

    func testLoadPerformancesNetworkFailureSetsErrorMessage() async {
        
        let mock = MockNetworkService()
        mock.errorToThrow = .noData

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = VenueDetailViewModel(venue: venue, repository: repo)

        await viewModel.loadPerformances()

        XCTAssertTrue(viewModel.performances.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testLoadPerformancesEmbedsArtistInfo() async {
        
        let performances = makePerformances(relative: [1])

        let mock = MockNetworkService()
        mock.responses["/venues/3/performances"] = performances

        let repo = VenueRepository(networkService: mock, cacheService: MockCacheService())
        let viewModel  = VenueDetailViewModel(venue: venue, repository: repo)

        await viewModel.loadPerformances()

        let first = try? XCTUnwrap(viewModel.performances.first)
        XCTAssertEqual(first?.artist.name, "Beat Illuminati")
    }
}
