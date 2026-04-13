//
//  NetworkError.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse
    case invalidStatusCode(Int, APIErrorResponse?)
    case decodingFailed
    case encodingFailed
    case transportError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server returned an invalid response."
        case let .invalidStatusCode(_, apiError):
            return apiError?.description ?? "The request could not be completed."
        case .decodingFailed:
            return "Failed to decode the server response."
        case .encodingFailed:
            return "Failed to encode the request body."
        case let .transportError(error):
            return error.localizedDescription
        }
    }
}
