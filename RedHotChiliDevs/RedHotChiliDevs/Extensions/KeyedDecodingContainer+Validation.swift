//
//  KeyedDecodingContainer+Validation.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import Foundation

extension KeyedDecodingContainer {
    
    /// Decodes a date from API string format (yyyy-MM-dd HH:mm:ss)
    ///
    /// - Parameter key: The key for the date field in the JSON
    /// - Returns: The decoded `Date` object
    /// - Throws: `DecodingError` if the string is not in the expected format
    ///
    /// Example usage:
    /// ```swift
    /// let date = try container.decodeAPIDate(forKey: .createdAt)
    /// ```
    nonisolated func decodeAPIDate(forKey key: Key) throws -> Date {
        
        let dateString = try decode(String.self, forKey: key)
        guard let date = DateFormatter.apiDateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: key,
                                                   in: self,
                                                   debugDescription: "Date string '\(dateString)' is not in 'yyyy-MM-dd HH:mm:ss' format")
        }
        return date
    }
    
    /// Decodes an optional date from API string format (yyyy-MM-dd HH:mm:ss)
    ///
    /// - Parameter key: The key for the date field in the JSON
    /// - Returns: The decoded `Date?` object, or `nil` if the key doesn't exist
    /// - Throws: `DecodingError` if the string exists but is not in the expected format
    nonisolated func decodeAPIDateIfPresent(forKey key: Key) throws -> Date? {
        
        guard let dateString = try decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        
        guard let date = DateFormatter.apiDateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: key,
                                                   in: self,
                                                   debugDescription: "Date string '\(dateString)' is not in 'yyyy-MM-dd HH:mm:ss' format")
        }
        return date
    }
}
