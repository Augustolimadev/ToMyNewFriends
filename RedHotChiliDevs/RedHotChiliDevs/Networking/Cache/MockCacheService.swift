//
//  MockCacheService.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 10/4/2026.
//

import Foundation

/// In-memory cache with no TTL — for use in unit tests.
final class MockCacheService: CacheServiceProtocol {

    private var storage: [String: Any] = [:]

    func set<T: Codable>(_ value: T, forKey key: String) {
        storage[key] = value
    }

    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        storage[key] as? T
    }

    func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }

    func clearAll() {
        storage.removeAll()
    }
}
