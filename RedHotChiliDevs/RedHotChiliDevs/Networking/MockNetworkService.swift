//
//  MockNetworkService.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

/// A test-double for `NetworkServiceProtocol`.
/// Pre-load `responses` with keyed data (use `APIEndpoint.path` as the key)
/// or set `errorToThrow` to simulate failures.
final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {

    // MARK: - Configuration

    /// Keyed by `APIEndpoint.path`. Values must match the requested `Decodable` type.
    var responses: [String: Any] = [:]

    /// When non-nil, every call throws this error instead of returning data.
    var errorToThrow: NetworkError?

    // MARK: - Endpoints
    /// All endpoints that were requested, in order.
    private(set) var requestedEndpoints: [String] = []

    // MARK: - NetworkServiceProtocol
    func fetch<T: Decodable & Sendable>(_ type: T.Type, from endpoint: APIEndpoint) async throws -> T {
        
        requestedEndpoints.append(endpoint.path)

        if let error = errorToThrow {
            throw error
        }

        guard let value = responses[endpoint.path] as? T else {
            throw NetworkError.noData
        }

        return value
    }

    // MARK: - Helpers
    func reset() {
        responses = [:]
        errorToThrow = nil
        requestedEndpoints = []
    }
}
