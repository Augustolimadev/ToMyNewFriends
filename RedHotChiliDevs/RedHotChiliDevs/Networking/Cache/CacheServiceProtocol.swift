//
//  CacheServiceProtocol.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

protocol CacheServiceProtocol {
    
    /// Stores a `Codable` value under the given key.
    func set<T: Codable>(_ value: T, forKey key: String)

    /// Retrieves a previously stored value. Returns `nil` if absent or expired.
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T?

    /// Removes the value for a specific key.
    func remove(forKey key: String)

    /// Removes all cached values.
    func clearAll()
}
