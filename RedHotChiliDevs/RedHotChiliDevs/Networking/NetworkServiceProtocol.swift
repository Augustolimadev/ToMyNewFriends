//
//  NetworkServiceProtocol.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 9/4/2026.
//

import Foundation

/// Abstraction over the HTTP transport layer.
/// Conforming types must be `Sendable` so they can be used safely in async contexts.
protocol NetworkServiceProtocol: Sendable {
    func fetch<T: Decodable & Sendable>(_ type: T.Type, from endpoint: APIEndpoint) async throws -> T
}
