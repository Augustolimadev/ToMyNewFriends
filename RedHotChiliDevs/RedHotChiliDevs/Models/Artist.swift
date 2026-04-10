//
//  Artist.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

struct Artist: Identifiable, Hashable, Sendable {
    
    let id: Int
    let name: String
    let genre: String

    var imageURL: URL? {
        
        guard let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }
        return URL(string: "https://songleap.s3.amazonaws.com/artists/\(encoded).png")
        
    }
}

// MARK: - Codable Conformance
extension Artist: Codable {
    
    // Explicitly nonisolated conformance
    nonisolated init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.genre = try container.decode(String.self, forKey: .genre)
    }
    
    nonisolated func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(genre, forKey: .genre)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, genre
    }
}

