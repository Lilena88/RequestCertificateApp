//
//  APIClient.swift
//  Zalex
//

import Foundation

protocol APIClientProtocol: Sendable {
    func get<T: Decodable>(endpoint: APIEndpoint) async throws -> T
    func post<T: Decodable, B: Encodable>(endpoint: APIEndpoint, body: B) async throws -> T
}

struct CertificateSubmitResponse: Decodable {
    let responce: String
}

final class URLSessionAPIClient: APIClientProtocol, @unchecked Sendable {
    private let session: URLSession
    private let apiKey: String?

    init(session: URLSession = .shared, apiKey: String? = APIConfiguration.apiKey) {
        self.session = session
        self.apiKey = apiKey
    }

    func get<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        let request = buildRequest(for: endpoint)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }

        return try handleResponse(data: data, response: response)
    }

    func post<T: Decodable, B: Encodable>(endpoint: APIEndpoint, body: B) async throws -> T {
        var request = buildRequest(for: endpoint)

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw APIError.encodingError(error)
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }

        return try handleResponse(data: data, response: response)
    }

    // MARK: - Private

    private func buildRequest(for endpoint: APIEndpoint) -> URLRequest {
        let url = endpoint.url(apiKey: apiKey)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        let statusCode = httpResponse.statusCode

        switch statusCode {
        case 200...299:
            break
        case 400...499:
            throw APIError.clientError(statusCode)
        case 500...599:
            throw APIError.serverError(statusCode)
        default:
            throw APIError.serverError(statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}
