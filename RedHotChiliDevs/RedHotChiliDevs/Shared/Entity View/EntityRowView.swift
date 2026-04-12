//
//  EntityRowView.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

/// Reusable row used in both Artists and Venues list views.
struct EntityRowView: View {

    let name: String
    let subtitle: String?
    let imageURL: URL?

    var body: some View {
        
        HStack(spacing: 14) {
            
            AsyncEntityImage(url: imageURL, cornerRadius: 10)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    EntityRowView(
        name: "Beat Illuminati",
        subtitle: "Dance",
        imageURL: nil
    )
    .padding()
}
