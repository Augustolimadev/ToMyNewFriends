//
//  ArtistsListView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

struct ArtistsListView: View {

    @Environment(\.artistRepository) private var repository
    @Environment(\.navigationRouter) private var router
    @State private var viewModel: ArtistsListViewModel?

    var body: some View {
        content
            .navigationTitle(Strings.Artists.navTitle)
            .task {
                let vm = ArtistsListViewModel(repository: repository)
                viewModel = vm
                await vm.loadArtists()
            }
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        
        if let viewModel {
            if viewModel.isLoading {
                ProgressView(Strings.Artists.loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                errorView(message: error, viewModel: viewModel)
            } else {
                artistList(viewModel: viewModel)
            }
        } else {
            ProgressView()
        }
    }

    private func artistList(viewModel: ArtistsListViewModel) -> some View {
        
        List(viewModel.artists) { artist in
            Button {
                router.navigate(to: .artistDetail(artist))
            } label: {
                EntityRowView(
                    name: artist.name,
                    subtitle: artist.genre,
                    imageURL: artist.imageURL
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .refreshable {
            await viewModel.loadArtists()
        }
    }

    private func errorView(message: String, viewModel: ArtistsListViewModel) -> some View {
        
        ContentUnavailableView {
            Label(Strings.Common.failedToLoad, systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button(Strings.Common.retry) {
                Task { await viewModel.loadArtists() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigableView {
        ArtistsListView()
    }
}
