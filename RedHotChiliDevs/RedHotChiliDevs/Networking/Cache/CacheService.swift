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
    func set<T: Codable>(_ value: T, forKey key: String) {
        
        guard let data = try? encoder.encode(value) else { return }
        
        lock.withLock {
            let entry = Entry(data: data, expiresAt: Date().addingTimeInterval(ttl))
            storage.setObject(entry, forKey: key as NSString)
        }
    }

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
