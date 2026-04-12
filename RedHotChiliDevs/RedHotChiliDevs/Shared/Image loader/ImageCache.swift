//
//  ImageCache.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 12/4/2026.
//

import UIKit
import Foundation

// MARK: - Image Cache Protocol

/// Protocol defining image caching capabilities
protocol ImageCacheProtocol: Sendable {
    
    /// Retrieves an image from cache
    func image(for url: URL) -> UIImage?
    
    /// Stores an image in cache
    func store(_ image: UIImage, for url: URL)
    
    /// Removes an image from cache
    func removeImage(for url: URL)
    
    /// Clears all cached images
    func clearCache()
}

// MARK: - Image Cache

/// Two-tier image cache with memory and disk storage
///
/// Architecture:
/// - **Memory Cache**: Fast, limited capacity (NSCache)
/// - **Disk Cache**: Slower, larger capacity (FileManager)
/// - **TTL**: Time-to-live for cache invalidation
///
/// Usage:
/// ```swift
/// let cache = ImageCache.shared
/// if let image = cache.image(for: url) {
///     // Use cached image
/// } else {
///     // Download and cache
///     cache.store(image, for: url)
/// }
/// ```
final class ImageCache: ImageCacheProtocol, @unchecked Sendable {
    
    // MARK: - Singleton
    static let shared = ImageCache()
    
    // MARK: - Properties
    /// In-memory cache (fast access, limited capacity)
    private let memoryCache = NSCache<NSURL, UIImage>()
    
    /// Disk cache directory
    private let diskCacheURL: URL
    
    /// File manager for disk operations
    private let fileManager = FileManager.default
    
    /// Serial queue for thread-safe disk operations
    private let diskQueue = DispatchQueue(label: "com.redhotchilidevs.imagecache.disk", qos: .utility)
    
    /// Maximum memory cache size (in MB)
    private let maxMemoryCacheSizeMB: Int = 50
    
    /// Maximum disk cache size (in MB)
    private let maxDiskCacheSizeMB: Int = 200
    
    /// Time-to-live for cached images (1 days)
    private let cacheTTL: TimeInterval = 24 * 60 * 60
    
    // MARK: - Initialization
    private init() {
        
        // Configure memory cache
        memoryCache.totalCostLimit = maxMemoryCacheSizeMB * 1024 * 1024
        memoryCache.countLimit = 100 // Max 100 images in memory
        
        // Setup disk cache directory
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskCacheURL = cacheDirectory.appendingPathComponent("ImageCache", isDirectory: true)
        
        // Create disk cache directory if needed
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        
        // Setup cache cleanup on memory warning
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearMemoryCache),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
        
        // Cleanup expired cache on init
        Task {
            await cleanupExpiredCache()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - ImageCacheProtocol
    func image(for url: URL) -> UIImage? {
        
        let key = url as NSURL
        
        // Try memory cache first (fast)
        if let cachedImage = memoryCache.object(forKey: key) {
            return cachedImage
        }
        
        // Try disk cache (slower but persistent)
        if let diskImage = loadFromDisk(url: url) {
            // Promote to memory cache
            memoryCache.setObject(diskImage, forKey: key)
            return diskImage
        }
        
        return nil
    }
    
    func store(_ image: UIImage, for url: URL) {
        
        let key = url as NSURL
        
        // Store in memory cache
        let cost = Int(image.size.width * image.size.height * 4) // Approximate byte size
        memoryCache.setObject(image, forKey: key, cost: cost)
        
        // Store in disk cache asynchronously
        diskQueue.async { [weak self] in
            self?.saveToDisk(image: image, url: url)
        }
    }
    
    func removeImage(for url: URL) {
        
        let key = url as NSURL
        
        // Remove from memory
        memoryCache.removeObject(forKey: key)
        
        // Remove from disk
        diskQueue.async { [weak self] in
            guard let self = self else { return }
            let fileURL = self.diskFileURL(for: url)
            try? self.fileManager.removeItem(at: fileURL)
        }
    }
    
    func clearCache() {
        clearMemoryCache()
        clearDiskCache()
    }
    
    // MARK: - Memory Cache
    @objc private func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }
    
    // MARK: - Disk Cache
    private func diskFileURL(for url: URL) -> URL {
        let filename = url.absoluteString.sha256Hash
        return diskCacheURL.appendingPathComponent(filename)
    }
    
    private func loadFromDisk(url: URL) -> UIImage? {
        
        let fileURL = diskFileURL(for: url)
        
        // Check if file exists
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        // Check if expired
        if isCacheExpired(fileURL: fileURL) {
            try? fileManager.removeItem(at: fileURL)
            return nil
        }
        
        // Load image
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    private func saveToDisk(image: UIImage, url: URL) {
        
        guard let data = image.pngData() else { return }
        
        let fileURL = diskFileURL(for: url)
        try? data.write(to: fileURL, options: .atomic)
        
        // Cleanup if cache is too large
        Task {
            await cleanupIfNeeded()
        }
    }
    
    private func clearDiskCache() {
        
        diskQueue.async { [weak self] in
            guard let self = self else { return }
            try? self.fileManager.removeItem(at: self.diskCacheURL)
            try? self.fileManager.createDirectory(at: self.diskCacheURL, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Cache Management
    private func isCacheExpired(fileURL: URL) -> Bool {
        
        guard let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
              let modificationDate = attributes[.modificationDate] as? Date else {
            return true
        }
        
        return Date().timeIntervalSince(modificationDate) > cacheTTL
    }
    
    private func cleanupExpiredCache() async {
        
        diskQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let fileURLs = try? self.fileManager.contentsOfDirectory(
                at: self.diskCacheURL,
                includingPropertiesForKeys: [.contentModificationDateKey],
                options: .skipsHiddenFiles
            ) else { return }
            
            for fileURL in fileURLs {
                if self.isCacheExpired(fileURL: fileURL) {
                    try? self.fileManager.removeItem(at: fileURL)
                }
            }
        }
    }
    
    private func cleanupIfNeeded() async {
        
        diskQueue.async { [weak self] in
            guard let self = self else { return }
            
            let cacheSize = self.calculateDiskCacheSize()
            let maxSize = Int64(self.maxDiskCacheSizeMB) * 1024 * 1024
            
            guard cacheSize > maxSize else { return }
            
            // Remove oldest files first
            self.removeOldestFiles(untilSize: maxSize)
        }
    }
    
    private func calculateDiskCacheSize() -> Int64 {
        
        guard let fileURLs = try? fileManager.contentsOfDirectory(
            at: diskCacheURL,
            includingPropertiesForKeys: [.fileSizeKey],
            options: .skipsHiddenFiles
        ) else { return 0 }
        
        return fileURLs.reduce(0) { total, fileURL in
            guard let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey]),
                  let fileSize = resourceValues.fileSize else {
                return total
            }
            return total + Int64(fileSize)
        }
    }
    
    private func removeOldestFiles(untilSize maxSize: Int64) {
        
        guard let fileURLs = try? fileManager.contentsOfDirectory(
            at: diskCacheURL,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey],
            options: .skipsHiddenFiles
        ) else { return }
        
        // Sort by modification date (oldest first)
        let sortedFiles = fileURLs.sorted { url1, url2 in
            guard let date1 = (try? url1.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate,
                  let date2 = (try? url2.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate else {
                return false
            }
            return date1 < date2
        }
        
        // Remove files until under size limit
        var currentSize = calculateDiskCacheSize()
        for fileURL in sortedFiles {
            guard currentSize > maxSize else { break }
            
            if let fileSize = (try? fileURL.resourceValues(forKeys: [.fileSizeKey]))?.fileSize {
                try? fileManager.removeItem(at: fileURL)
                currentSize -= Int64(fileSize)
            }
        }
    }
    
    // MARK: - Statistics (for debugging)
    func getCacheStatistics() -> CacheStatistics {
        
        let diskSize = calculateDiskCacheSize()
        let fileCount = (try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: nil))?.count ?? 0
        
        return CacheStatistics(
            memoryCacheCount: memoryCache.countLimit,
            diskCacheSizeBytes: diskSize,
            diskCacheFileCount: fileCount
        )
    }
}

// MARK: - Cache Statistics
struct CacheStatistics {
    
    let memoryCacheCount: Int
    let diskCacheSizeBytes: Int64
    let diskCacheFileCount: Int
    
    var diskCacheSizeMB: Double {
        Double(diskCacheSizeBytes) / (1024 * 1024)
    }
}
