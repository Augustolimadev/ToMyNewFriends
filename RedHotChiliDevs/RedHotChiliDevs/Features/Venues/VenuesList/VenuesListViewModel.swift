//
//  VenuesListViewModel.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation
import Observation

@Observable
final class VenuesListViewModel {

    // MARK: - State
    private(set) var venues: [Venue] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies
    private let repository: VenueRepositoryProtocol

    // MARK: - Init
    init(repository: VenueRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Actions
    @MainActor
    func loadVenues() async {
        
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil

        do {
            venues = try await repository.fetchVenues()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

