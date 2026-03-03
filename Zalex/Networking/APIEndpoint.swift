//
//  APIEndpoint.swift
//  Zalex
//

import Foundation

enum APIEndpoint {
    case requestCertificate
    case requestList

    var path: String {
        switch self {
        case .requestCertificate: return "request-certificate"
        case .requestList: return "request-list"
        }
    }

    var httpMethod: String {
        switch self {
        case .requestCertificate: return "POST"
        case .requestList: return "GET"
        }
    }

    func url(apiKey: String?) -> URL {
        var components = URLComponents(url: APIConfiguration.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        if let key = apiKey, !key.isEmpty {
            components.queryItems = [URLQueryItem(name: "subscription-key", value: key)]
        }
        guard let url = components.url else {
            fatalError("Invalid endpoint URL for \(path)")
        }
        return url
    }
}
