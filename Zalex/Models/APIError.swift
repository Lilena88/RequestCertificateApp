//
//  APIError.swift
//  Zalex
//

import Foundation

enum APIError: LocalizedError {
    case invalidResponse
    case networkError(Error)
    case decodingError
    case encodingError(Error)
    case validationFailed
    case serverError(Int)
    case clientError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return NSLocalizedString("Invalid response from server.", comment: "API error")
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError:
            return NSLocalizedString("Failed to decode server response.", comment: "API error")
        case .encodingError(let error):
            return error.localizedDescription
        case .validationFailed:
            return NSLocalizedString("Validation failed.", comment: "API error")
        case .serverError(let code):
            return String(format: NSLocalizedString("Server error (code %d).", comment: "API error"), code)
        case .clientError(let code):
            return String(format: NSLocalizedString("Client error (code %d).", comment: "API error"), code)
        }
    }
}
