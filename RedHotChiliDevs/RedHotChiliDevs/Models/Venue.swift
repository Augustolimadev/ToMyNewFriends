//
//  Venue.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

struct Venue: Identifiable, Codable, Hashable, Sendable {
    
    let id: Int
    let name: String
    let sortId: Int

    var imageURL: URL? {
        
        guard let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }
        return URL(string: "https://songleap.s3.amazonaws.com/venues/\(encoded).png")
    }
}
