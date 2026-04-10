//
//  NetworkService.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        
        self.session = session

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // "2023-07-01T20:00:00Z"
        self.decoder = decoder
    }

    func fetch<T: Decodable & Sendable>(_ type: T.Type, from endpoint: APIEndpoint) async throws -> T {
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(type, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError.localizedDescription)
        } catch {
            throw NetworkError.unknown(error.localizedDescription)
        }
    }
}
