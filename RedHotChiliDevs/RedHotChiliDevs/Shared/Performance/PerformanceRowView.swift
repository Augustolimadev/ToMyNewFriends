//
//  PerformanceRowView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import SwiftUI

/// A single row inside a performance list.
/// Shows a thumbnail image (artist or venue), name, and formatted date/time.
struct PerformanceRowView: View {

    let title: String
    let subtitle: String?
    let imageURL: URL?
    let dateTime: Date

    var body: some View {
        
        HStack(spacing: 14) {
            AsyncEntityImage(url: imageURL, cornerRadius: 8)
                .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }

                Text(dateTime.dateTimeBaseFormat)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PerformanceRowView(
        title: "Cobblequill Colosseum",
        subtitle: "Live Music",
        imageURL: nil,
        dateTime: Date()
    )
    .padding()
}
