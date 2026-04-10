//
//  NetworkError.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(String)
    case noData
    case unknown(String)

    var errorDescription: String? {
        
        switch self {
        case .invalidURL:              "The URL is invalid."
        case .invalidResponse:         "The server returned an invalid response."
        case .statusCode(let code):    "Server error with status code \(code)."
        case .decodingError(let msg):  "Failed to decode response: \(msg)"
        case .noData:                  "No data was returned."
        case .unknown(let msg):        msg
        }
    }
}
