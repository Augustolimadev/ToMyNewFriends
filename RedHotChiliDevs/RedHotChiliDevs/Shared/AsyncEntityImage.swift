//
//  AsyncEntityImage.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

/// Loads an image from a remote URL with a styled placeholder and error state.
/// Relies on `AsyncImage` which uses `URLCache` for automatic disk caching.
struct AsyncEntityImage: View {

    let url: URL?
    var cornerRadius: CGFloat = 12
    var aspectRatio: ContentMode = .fill

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.secondary.opacity(0.15)
                    ProgressView()
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: aspectRatio)
            case .failure:
                ZStack {
                    Color.secondary.opacity(0.15)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            @unknown default:
                EmptyView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    AsyncEntityImage(url: URL(string: "https://picsum.photos/200"))
        .frame(width: 180, height: 180)
}
