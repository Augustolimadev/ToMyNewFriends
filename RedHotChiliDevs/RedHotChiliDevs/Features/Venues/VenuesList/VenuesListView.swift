//
//  VenuesListView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

struct VenuesListView: View {

    @Environment(\.venueRepository) private var repository
    @State private var viewModel: VenuesListViewModel?

    var body: some View {
        
        NavigationStack {
            content
                .navigationTitle(Strings.Venues.navTitle)
        }
        .task {
            let vm = VenuesListViewModel(repository: repository)
            viewModel = vm
            await vm.loadVenues()
        }
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        
        if let viewModel {
            if viewModel.isLoading {
                ProgressView(Strings.Venues.loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                errorView(message: error, viewModel: viewModel)
            } else {
                venueList(viewModel: viewModel)
            }
        } else {
            ProgressView()
        }
    }

    private func venueList(viewModel: VenuesListViewModel) -> some View {
        
        List(viewModel.venues) { venue in
            NavigationLink(value: venue) {
                EntityRowView(
                    name: venue.name,
                    subtitle: nil,
                    imageURL: venue.imageURL
                )
            }
        }
//        .navigationDestination(for: Venue.self) { venue in
//            VenueDetailView(venue: venue)
//        }
        .refreshable {
            await viewModel.loadVenues()
        }
    }

    private func errorView(message: String, viewModel: VenuesListViewModel) -> some View {
        
        ContentUnavailableView {
            Label(Strings.Common.failedToLoad, systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button(Strings.Common.retry) {
                Task { await viewModel.loadVenues() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    VenuesListView()
}
