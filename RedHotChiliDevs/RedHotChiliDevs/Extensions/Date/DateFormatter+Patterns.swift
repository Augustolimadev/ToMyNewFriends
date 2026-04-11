//
//  DateFormatter+Patterns.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import Foundation

// MARK: - API Date Formatter
extension DateFormatter {
    
    /// Base format used for layout.
    /// dateStyle = medium
    /// timeStyle = short
    static let baseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// Shared formatter for API dates in "yyyy-MM-dd HH:mm:ss" format
    ///
    /// This formatter is thread-safe and reusable throughout the application.
    /// Use it via the `KeyedDecodingContainer` and `KeyedEncodingContainer` extensions.
    nonisolated static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
