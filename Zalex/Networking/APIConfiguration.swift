//
//  APIConfiguration.swift
//  Zalex
//

import Foundation

enum APIConfiguration {
    private static let baseURLString = "https://zalexinc.azure-api.net"
    private static let apiKeyEnvironmentVariable = "ZALEX_API_KEY"

    static var baseURL: URL {
        guard let url = URL(string: baseURLString) else {
            fatalError("Invalid base URL: \(baseURLString)")
        }
        return url
    }
    static var apiKey: String? {
        ProcessInfo.processInfo.environment[apiKeyEnvironmentVariable]
    }
}
