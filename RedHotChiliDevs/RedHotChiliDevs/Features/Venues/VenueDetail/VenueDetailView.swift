//
//  VenueDetailView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import SwiftUI

struct VenueDetailView: View {

    @Environment(\.venueRepository) private var repository
    @State private var viewModel: VenueDetailViewModel?

    let venue: Venue

    var body: some View {
        content
            .navigationTitle(venue.name)
            .navigationBarTitleDisplayMode(.large)
            .task {
                let vm = VenueDetailViewModel(venue: venue, repository: repository)
                viewModel = vm
                await vm.loadPerformances()
            }
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        
        if let viewModel {
            if viewModel.isLoading {
                ProgressView(Strings.Performances.loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                errorView(message: error, viewModel: viewModel)
            } else {
                detailContent(viewModel: viewModel)
            }
        } else {
            ProgressView()
        }
    }

    private func detailContent(viewModel: VenueDetailViewModel) -> some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                EntityHeaderView(imageURL: venue.imageURL)

                VenuePerformancesListView(performances: viewModel.performances)
            }
            .padding(.bottom)
        }
        .refreshable {
            await viewModel.loadPerformances()
        }
    }

    private func errorView(message: String, viewModel: VenueDetailViewModel) -> some View {
        ErrorStateView(message: message) {
            await viewModel.loadPerformances()
        }
    }
}

#Preview {
    NavigationStack {
        VenueDetailView(venue: Venue(
            id: 3,
            name: "Cobblequill Colosseum",
            sortId: 1)
        )
    }
}
