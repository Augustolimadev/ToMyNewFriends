//
//  Artist.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

struct Artist: Identifiable, Codable, Hashable, Sendable {
    
    let id: Int
    let name: String
    let genre: String

    var imageURL: URL? {
        
        guard let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }
        return URL(string: "https://myimagesstorage.amazonaws.com/artists/\(encoded).png")
    }
}
