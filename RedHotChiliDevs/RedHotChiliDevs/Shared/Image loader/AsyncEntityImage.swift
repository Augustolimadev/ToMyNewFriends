//
//  AsyncEntityImage.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import SwiftUI

/// Async image loader with caching, placeholders, and error handling
///
/// Features:
/// - Two-tier caching (memory + disk)
/// - Automatic task cancellation
/// - Placeholder while loading
/// - Error state handling
/// - Accessibility support
///
/// Usage:
/// ```swift
/// AsyncEntityImage(url: artist.imageURL)
///
/// AsyncEntityImage(
///     url: venue.imageURL,
///     cornerRadius: 16,
///     aspectRatio: .fit
/// )
/// ```
struct AsyncEntityImage: View {
    
    // MARK: - Properties
    let url: URL?
    let cornerRadius: CGFloat
    let aspectRatio: ContentMode
    
    @State private var loader: ImageLoader
    
    // MARK: - Initialization
    init(url: URL?,
         cornerRadius: CGFloat = 12,
         aspectRatio: ContentMode = .fill) {
        
        self.url = url
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
        self._loader = State(initialValue: ImageLoader(url: url))
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: aspectRatio)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
            } else if loader.isLoading {
                placeholderView
                
            } else if loader.error != nil {
                errorView
                
            } else {
                placeholderView
            }
        }
        .task {
            loader.load()
        }
    }
    
    // MARK: - Subviews
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.2))
            .overlay {
                ProgressView()
                    .tint(.gray)
            }
    }
    
    private var errorView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.1))
            .overlay {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
    }
}

// MARK: - Preview
#Preview("Loading State") {
    AsyncEntityImage(url: nil)
        .frame(width: 100, height: 100)
}

#Preview("With URL") {
    AsyncEntityImage(
        url: URL(string: "https://picsum.photos/200"),
        cornerRadius: 16
    )
    .frame(width: 200, height: 200)
}

#Preview("Different Sizes") {
    VStack(spacing: 20) {
        AsyncEntityImage(
            url: URL(string: "https://picsum.photos/300"),
            cornerRadius: 8
        )
        .frame(width: 60, height: 60)
        
        AsyncEntityImage(
            url: URL(string: "https://picsum.photos/300"),
            cornerRadius: 12
        )
        .frame(width: 100, height: 100)
        
        AsyncEntityImage(
            url: URL(string: "https://picsum.photos/300"),
            cornerRadius: 16,
            aspectRatio: .fit
        )
        .frame(height: 200)
    }
    .padding()
}
