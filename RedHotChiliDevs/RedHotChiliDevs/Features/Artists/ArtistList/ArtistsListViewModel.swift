//
//  ArtistsListViewModel.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation
import Observation

@Observable
final class ArtistsListViewModel {

    // MARK: - State
    private(set) var artists: [Artist] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies
    private let repository: ArtistRepositoryProtocol

    // MARK: - Init
    init(repository: ArtistRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Actions

    @MainActor
    func loadArtists() async {
        
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        
        errorMessage = nil

        do {
            artists = try await repository.fetchArtists()
        } catch {
            errorMessage = error.localizedDescription
        }

//        isLoading = false
    }
}

