//
//  VenueDetailViewModel.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import Foundation
import Observation

@Observable
final class VenueDetailViewModel {

    // MARK: - State
    private(set) var performances: [VenuePerformance] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    let venue: Venue

    // MARK: - Dependencies
    private let repository: VenueRepositoryProtocol

    // MARK: - Init
    init(venue: Venue, repository: VenueRepositoryProtocol) {
        self.venue = venue
        self.repository = repository
    }

    // MARK: - Actions
    /// Loads performances for today + 14 days.
    @MainActor
    func loadPerformances() async {
        
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil

        let today = Calendar.current.startOfDay(for: Date())
        let twoWeeksLater = Calendar.current.date(byAdding: .day, value: 14, to: today)

        do {
            performances = try await repository.fetchPerformances(
                for: venue.id,                                
                from: today,
                to: twoWeeksLater
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
