//
//  KeyedEncodingContainer+Validation.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import Foundation

extension KeyedEncodingContainer {
    
    /// Encodes a date as a string in API format (yyyy-MM-dd HH:mm:ss)
    ///
    /// - Parameters:
    ///   - date: The `Date` object to be encoded
    ///   - key: The key for the date field in the JSON
    /// - Throws: `EncodingError` if encoding fails
    ///
    /// Example usage:
    /// ```swift
    /// try container.encodeAPIDate(createdAt, forKey: .createdAt)
    /// ```
    nonisolated mutating func encodeAPIDate(_ date: Date, forKey key: Key) throws {
        let dateString = DateFormatter.apiDateFormatter.string(from: date)
        try encode(dateString, forKey: key)
    }
    
    /// Encodes an optional date as a string in API format (yyyy-MM-dd HH:mm:ss)
    ///
    /// - Parameters:
    ///   - date: The optional `Date?` object to be encoded
    ///   - key: The key for the date field in the JSON
    /// - Throws: `EncodingError` if encoding fails
    nonisolated mutating func encodeAPIDateIfPresent(_ date: Date?, forKey key: Key) throws {
        guard let date = date else { return }
        try encodeAPIDate(date, forKey: key)
    }
}
