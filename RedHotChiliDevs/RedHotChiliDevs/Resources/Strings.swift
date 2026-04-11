//
//  Strings.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

/// Centralised, type-safe access to every localised string in the app.
///
/// Each nested enum maps to one `.xcstrings` file (the `table` parameter).
/// This keeps every file small and focused — translators and reviewers only
/// open the file relevant to the feature they are working on.
///
/// Usage in non-SwiftUI code (ViewModels, errors, etc.):
///   `Strings.Artists.navTitle`
///
/// In SwiftUI Views pass the result to `Text(...)` directly:
///   `Text(Strings.Performances.sectionTitle)`
///
/// Adding a new language:
///   1. Add the language in Xcode: Project → Info → Localizations → +
///   2. Open the relevant `.xcstrings` file and fill in the new translations.
///   3. No changes needed here in Strings.swift.
///
/// Adding a new string:
///   1. Add the key + translation to the matching `.xcstrings` file.
///   2. Expose it here as a `static var` using `String(localized:table:)`.

enum Strings {
    
    // MARK: - Common  →  Resources/Strings/Common.xcstrings
    enum Common {
        static var retry: String {
            String(localized: "common.retry", table: "Common")
        }
        static var failedToLoad: String {
            String(localized: "common.failed_to_load", table: "Common")
        }
    }
    
    // MARK: - Network Errors  →  Resources/Strings/NetworkErrors.xcstrings
    enum Error {
        enum Network {
            static var invalidURL: String {
                String(localized: "error.network.invalid_url", table: "NetworkErrors")
            }
            static var invalidResponse: String {
                String(localized: "error.network.invalid_response", table: "NetworkErrors")
            }
            static func statusCode(_ code: Int) -> String {
                String(localized: "error.network.status_code \(code)", table: "NetworkErrors")
            }
            static func decodingError(_ message: String) -> String {
                String(localized: "error.network.decoding_error \(message)", table: "NetworkErrors")
            }
            static var noData: String {
                String(localized: "error.network.no_data", table: "NetworkErrors")
            }
        }
    }
    
    // MARK: - Artists  →  Resources/Strings/Artists.xcstrings
    enum Artists {
        static var tabTitle: String {
            String(localized: "artists.tab_title", table: "Artists")
        }
        static var navTitle: String {
            String(localized: "artists.nav_title", table: "Artists")
        }
        static var loading: String {
            String(localized: "artists.loading", table: "Artists")
        }
    }
    
    // MARK: - Venues  →  Resources/Strings/Venues.xcstrings
    enum Venues {
        static var tabTitle: String {
            String(localized: "venues.tab_title", table: "Venues")
        }
        static var navTitle: String {
            String(localized: "venues.nav_title", table: "Venues")
        }
        static var loading: String {
            String(localized: "venues.loading", table: "Venues")
        }
    }
    
    // MARK: - Performances  →  Resources/Strings/Performances.xcstrings
    enum Performances {
        static var sectionTitle: String {
            String(localized: "performances.section_title", table: "Performances")
        }
        static var loading: String {
            String(localized: "performances.loading", table: "Performances")
        }
        static var empty: String {
            String(localized: "performances.empty_title", table: "Performances")
        }
        static var emptyDescription: String {
            String(localized: "performances.empty_description", table: "Performances")
        }
    }
}
