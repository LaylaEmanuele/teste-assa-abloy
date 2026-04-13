//
//  DoorsService.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

protocol DoorsServicing {
    func fetchDoors(authToken: String, page: Int, size: Int) async throws -> DoorsResponse
    func findDoors(authToken: String, name: String, page: Int, size: Int) async throws -> DoorsResponse
}

@MainActor
struct DoorsService: DoorsServicing {
    func fetchDoors(authToken: String, page: Int = 0, size: Int = 20) async throws -> DoorsResponse {
        let apiClient = URLSessionAPIClient(tokenProvider: { authToken })
        let request = APIRequest(
            path: "/doors",
            method: .get,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]
        )

        return try await apiClient.send(request, as: DoorsResponse.self)
    }

    func findDoors(authToken: String, name: String, page: Int = 0, size: Int = 20) async throws -> DoorsResponse {
        let apiClient = URLSessionAPIClient(tokenProvider: { authToken })
        let request = APIRequest(
            path: "/doors/find",
            method: .get,
            queryItems: [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]
        )

        return try await apiClient.send(request, as: DoorsResponse.self)
    }
}
