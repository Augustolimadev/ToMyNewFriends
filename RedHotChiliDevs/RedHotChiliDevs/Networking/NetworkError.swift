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
        case .invalidURL:              Strings.Error.Network.invalidURL
        case .invalidResponse:         Strings.Error.Network.invalidResponse
        case .statusCode(let code):    Strings.Error.Network.statusCode(code)
        case .decodingError(let msg):  Strings.Error.Network.decodingError(msg)
        case .noData:                  Strings.Error.Network.noData
        case .unknown(let msg):        msg
        }
    }
}
