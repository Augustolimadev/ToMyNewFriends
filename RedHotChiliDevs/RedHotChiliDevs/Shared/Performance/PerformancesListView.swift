//
//  PerformancesListView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import SwiftUI

/// Reusable performances list section for artist performances
struct ArtistPerformancesListView: View {
    
    let performances: [ArtistPerformance]
    
    var body: some View {
        PerformancesSectionContent(isEmpty: performances.isEmpty,
                                   titleFont: .title.bold()) {
            
            ForEach(performances) { performance in
                PerformanceRowView(
                    title: performance.venue.name,
                    subtitle: nil,
                    imageURL: performance.venue.imageURL,
                    dateTime: performance.date
                )
                Divider().padding(.leading, 82)
            }
        }
    }
}

/// Reusable performances list section for venue performances
struct VenuePerformancesListView: View {
    
    let performances: [VenuePerformance]
    
    var body: some View {
        PerformancesSectionContent(isEmpty: performances.isEmpty,
                                   titleFont: .title.bold()) {
            
            ForEach(performances) { performance in
                PerformanceRowView(
                    title: performance.artist.name,
                    subtitle: performance.artist.genre,
                    imageURL: performance.artist.imageURL,
                    dateTime: performance.date
                )
                Divider().padding(.leading, 82)
            }
        }
    }
}

/// Shared layout component for performances sections
private struct PerformancesSectionContent<Content: View>: View {
    
    let isEmpty: Bool
    let titleFont: Font
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Strings.Performances.sectionTitle)
                .font(titleFont)
                .padding(.horizontal)
            
            if isEmpty {
                ContentUnavailableView(
                    Strings.Performances.empty,
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text(Strings.Performances.emptyDescription)
                )
            } else {
                LazyVStack(spacing: 4) {
                    content()
                }
                .background(Color(uiColor: .systemGroupedBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}

#Preview("Artist Performances") {
    ScrollView {
        ArtistPerformancesListView(performances: [])
    }
}

#Preview("Venue Performances") {
    ScrollView {
        VenuePerformancesListView(performances: [])
    }
}

