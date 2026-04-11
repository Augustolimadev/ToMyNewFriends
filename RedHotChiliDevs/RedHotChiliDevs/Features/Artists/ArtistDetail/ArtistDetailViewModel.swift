//
//  ArtistDetailViewModel.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Foundation
import Observation

@Observable
final class ArtistDetailViewModel {

    // MARK: - State
    private(set) var performances: [ArtistPerformance] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    let artist: Artist

    // MARK: - Dependencies
    private let repository: ArtistRepositoryProtocol

    // MARK: - Init
    init(artist: Artist, repository: ArtistRepositoryProtocol) {
        self.artist = artist
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
                for: artist.id,
                from: today,
                to: twoWeeksLater
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
