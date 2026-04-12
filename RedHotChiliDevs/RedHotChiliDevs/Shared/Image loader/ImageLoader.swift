//
//  ImageLoader.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 12/4/2026.
//

import UIKit
import Foundation
import Observation

// MARK: - Image Loader

/// Observable image loader with caching and cancellation support
///
/// Usage:
/// ```swift
/// @State private var loader = ImageLoader(url: imageURL)
///
/// loader.image // Returns UIImage?
/// loader.isLoading // Returns Bool
/// loader.error // Returns Error?
/// ```
@Observable
final class ImageLoader {
    
    // MARK: - State
    private(set) var image: UIImage?
    private(set) var isLoading = false
    private(set) var error: Error?
    
    // MARK: - Properties
    private let url: URL?
    private let cache: ImageCacheProtocol
    private var task: Task<Void, Never>?
    
    // MARK: - Initialization
    init(url: URL?, cache: ImageCacheProtocol = ImageCache.shared) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    // MARK: - Loading
    
    /// Loads the image from cache or network
    @MainActor
    func load() {
        
        guard let url = url else { return }
        
        // Cancel any existing task
        cancel()
        
        // Check cache first
        if let cachedImage = cache.image(for: url) {
            image = cachedImage
            isLoading = false
            error = nil
            return
        }
        
        // Download from network
        isLoading = true
        error = nil
        
        task = Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                // Validate response
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw ImageLoaderError.invalidResponse
                }
                
                // Decode image
                guard let downloadedImage = UIImage(data: data) else {
                    throw ImageLoaderError.invalidImageData
                }
                
                // Update UI on main actor
                await MainActor.run {
                    self.image = downloadedImage
                    self.isLoading = false
                    
                    // Cache the image
                    self.cache.store(downloadedImage, for: url)
                }
                
            } catch is CancellationError {
                // Task was cancelled - ignore
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Cancels the current loading task
    func cancel() {
        task?.cancel()
        task = nil
    }
}

// MARK: - Image Loader Error

enum ImageLoaderError: LocalizedError {
    
    case invalidResponse
    case invalidImageData
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "Invalid server response"
        case .invalidImageData:
            "Invalid image data"
        }
    }
}
