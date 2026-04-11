//
//  ArtistDetailView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import SwiftUI

struct ArtistDetailView: View {

    @Environment(\.artistRepository) private var repository
    @State private var viewModel: ArtistDetailViewModel?

    let artist: Artist

    var body: some View {
        content
            .navigationTitle(artist.name)
            .navigationBarTitleDisplayMode(.large)
            .task {
                let vm = ArtistDetailViewModel(artist: artist, repository: repository)
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

    private func detailContent(viewModel: ArtistDetailViewModel) -> some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncEntityImage(url: artist.imageURL, cornerRadius: 16, aspectRatio: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .padding(.horizontal)

                Label(artist.genre, systemImage: "music.note")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                
                performancesSection(viewModel: viewModel)
            }
            .padding(.bottom)
        }
        .refreshable {
            await viewModel.loadPerformances()
        }
    }

    private func performancesSection(viewModel: ArtistDetailViewModel) -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.Performances.sectionTitle)
                .font(.title.bold())
                .padding(.horizontal)

            if viewModel.performances.isEmpty {
                ContentUnavailableView(
                    Strings.Performances.empty,
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text(Strings.Performances.emptyDescription)
                )
            } else {
                LazyVStack(spacing: 4) {
                    ForEach(viewModel.performances) { performance in
                        PerformanceRowView(
                            title: performance.venue.name,
                            subtitle: nil,
                            imageURL: performance.venue.imageURL,
                            dateTime: performance.date
                        )
                        .padding(.horizontal)
                        Divider().padding(.leading, 82)
                    }
                }
            }
        }
    }

    private func errorView(message: String, viewModel: ArtistDetailViewModel) -> some View {
        
        ContentUnavailableView {
            Label(Strings.Common.failedToLoad, systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button(Strings.Common.retry) {
                Task { await viewModel.loadPerformances() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationStack {
        ArtistDetailView(artist: Artist(id: 7,
                                        name: "Beat Illuminati",
                                        genre: "Dance"))
    }
}
