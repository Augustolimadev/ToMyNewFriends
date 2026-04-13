//
//  CacheService.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

/// Thread-safe, TTL-aware in-memory cache backed by `NSCache`.
final class CacheService: CacheServiceProtocol {

    // MARK: - Types
    private final class Entry: NSObject {
        
        let data: Data
        let expiresAt: Date

        init(data: Data, expiresAt: Date) {
            self.data = data
            self.expiresAt = expiresAt
        }
    }

    // MARK: - Properties
    private let storage = NSCache<NSString, Entry>()
    private let ttl: TimeInterval
    private let lock = NSLock()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Init
    /// - Parameter ttl: Time-to-live in seconds. Default is 5 minutes.
    init(ttl: TimeInterval = 300) {
        self.ttl = ttl
    }

    // MARK: - CacheServiceProtocol
    
    /// Stores a `Codable` value in the cache for the given key.
    ///
    /// The value is encoded into `Data` and stored alongside an expiration date
    /// derived from the configured TTL (time-to-live).
    ///
    /// - Important:
    ///   - This method is thread-safe. Access to the underlying storage is synchronized via a lock.
    ///   - If encoding fails, the value will not be cached.
    ///
    /// - Parameters:
    ///   - value: The `Codable` value to cache.
    ///   - key: A unique identifier used to store and retrieve the value.
    func set<T: Codable>(_ value: T, forKey key: String) {
        
        guard let data = try? encoder.encode(value) else { return }
        
        lock.withLock {
            let entry = Entry(data: data, expiresAt: Date().addingTimeInterval(ttl))
            storage.setObject(entry, forKey: key as NSString)
        }
    }

    /// Retrieves a cached value for the given key if it exists, is not expired,
    /// and can be successfully decoded into the requested type.
    ///
    /// - Important:
    ///   - This method is thread-safe. Access to the underlying storage is synchronized via a lock.
    ///   - Expired entries are automatically evicted upon access (lazy eviction strategy).
    ///   - Decoding failures are silently ignored and treated as cache misses.
    ///
    /// - Parameters:
    ///   - type: The expected `Codable` type of the cached value.
    ///   - key: The unique identifier associated with the cached value.
    ///
    /// - Returns:
    ///   The decoded value if present, valid, and not expired; otherwise `nil`.
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        
        lock.withLock {
            guard let entry = storage.object(forKey: key as NSString) else { return nil }
            
            guard Date() < entry.expiresAt else {
                storage.removeObject(forKey: key as NSString)
                return nil
            }
            return try? decoder.decode(type, from: entry.data)
        }
    }

    func remove(forKey key: String) {
        lock.withLock {
            storage.removeObject(forKey: key as NSString)
        }
    }

    func clearAll() {
        lock.withLock {
            storage.removeAllObjects()
        }
    }
}
