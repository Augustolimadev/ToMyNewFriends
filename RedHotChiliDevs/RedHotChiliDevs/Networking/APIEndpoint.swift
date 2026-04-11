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
    case artistPerformances(id: Int, from: Date? = nil, to: Date? = nil)
    
    case venues
    case venuePerformances(id: Int, from: Date? = nil, to: Date? = nil)

    // MARK: - Path
    var path: String {
        
        switch self {
        case .artists:                           "/artists"
        case .artistPerformances(let id, _, _):  "/artists/\(id)/performances"
            
        case .venues:                            "/venues"
        case .venuePerformances(let id, _, _):   "/venues/\(id)/performances"
        }
    }

    // MARK: - Query Items
    var queryItems: [URLQueryItem] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch self {
        case .artistPerformances(_, let from, let to),
                .venuePerformances(_, let from, let to):
            var items: [URLQueryItem] = []
            if let from { items.append(URLQueryItem(name: "from", value: formatter.string(from: from))) }
            if let to   { items.append(URLQueryItem(name: "to",   value: formatter.string(from: to)))   }
            return items
        default:
            return []
        }
    }

    // MARK: - Resolved URL
    var url: URL? {
        
        var components = URLComponents(string: APIEndpoint.baseURL + path)
        let items = queryItems
        if !items.isEmpty { components?.queryItems = items }
        return components?.url
    }
}
