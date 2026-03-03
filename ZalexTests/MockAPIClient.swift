//
//  MockAPIClient.swift
//  ZalexTests
//

import Foundation
@testable import Zalex

final class MockAPIClient: APIClientProtocol {
    var getResult: (() async throws -> Any)?
    var postResult: (() async throws -> Any)?
    var getCallCount = 0
    var postCallCount = 0

    func get<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        getCallCount += 1
        guard let result = getResult else {
            throw APIError.invalidResponse
        }
        return try await result() as! T
    }

    func post<T: Decodable, B: Encodable>(endpoint: APIEndpoint, body: B) async throws -> T {
        postCallCount += 1
        guard let result = postResult else {
            throw APIError.invalidResponse
        }
        return try await result() as! T
    }
}
