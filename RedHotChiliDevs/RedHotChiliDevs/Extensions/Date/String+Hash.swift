//
//  String+Hash.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 12/4/2026.
//

import Foundation

// MARK: - String Hashing Extension
extension String {
    
    /// Creates a SHA256 hash of the string (for safe filenames)
    var sha256Hash: String {
        // Simple hash for filename - in production, use CryptoKit
        let hash = self.data(using: .utf8)?.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
        return hash ?? UUID().uuidString
    }
}
