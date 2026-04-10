//
//  APIEndpoint.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

enum APIEndpoint {

    static let baseURL = "https://api.leapmobileinterview.com"

    case artists
    case venues

    // MARK: - Path
    var path: String {
        
        switch self {
        case .artists: "/artists"
        case .venues: "/venues"
        }
    }

    // MARK: - Query Items
    var queryItems: [URLQueryItem] {
        []
    }

    // MARK: - Resolved URL
    var url: URL? {
        
        var components = URLComponents(string: APIEndpoint.baseURL + path)
        let items = queryItems
        if !items.isEmpty { components?.queryItems = items }
        return components?.url
    }
}
