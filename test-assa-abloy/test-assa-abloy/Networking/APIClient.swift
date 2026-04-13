//
//  APIClient.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

@MainActor
protocol APIClient {
    func send<Response: Decodable>(_ request: APIRequest, as responseType: Response.Type) async throws -> Response
    func send(_ request: APIRequest) async throws
}

struct URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let baseURL: URL
    private let defaultHeaders: [String: String]
    private let tokenProvider: () -> String?

    init(
        session: URLSession = .shared,
        baseURL: URL = AppEnvironment.baseURL,
        defaultHeaders: [String: String] = ["Accept": "application/json"],
        tokenProvider: @escaping () -> String? = { nil }
    ) {
        self.session = session
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.tokenProvider = tokenProvider
    }

    func send<Response: Decodable>(_ request: APIRequest, as responseType: Response.Type) async throws -> Response {
        let urlRequest = try makeURLRequest(from: request)

        do {
            let (data, response) = try await session.data(for: urlRequest)
            try validate(response: response, data: data)

            do {
                return try JSONDecoder.apiDecoder.decode(responseType, from: data)
            } catch {
                throw NetworkError.decodingFailed
            }
        } catch let error as NetworkError {
            throw error
        } catch is CancellationError {
            throw NetworkError.cancelled
        } catch let error as URLError where error.code == .cancelled {
            throw NetworkError.cancelled
        } catch {
            throw NetworkError.transportError(error)
        }
    }

    func send(_ request: APIRequest) async throws {
        let urlRequest = try makeURLRequest(from: request)

        do {
            let (_, response) = try await session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200 ..< 300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidStatusCode(httpResponse.statusCode, nil)
            }
        } catch let error as NetworkError {
            throw error
        } catch is CancellationError {
            throw NetworkError.cancelled
        } catch let error as URLError where error.code == .cancelled {
            throw NetworkError.cancelled
        } catch {
            throw NetworkError.transportError(error)
        }
    }

    private func makeURLRequest(from request: APIRequest) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appending(path: request.path), resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidResponse
        }

        if !request.queryItems.isEmpty {
            components.queryItems = request.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidResponse
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body

        let mergedHeaders = defaultHeaders
            .merging(request.headers) { _, new in new }
            .merging(authorizationHeader) { _, new in new }

        mergedHeaders.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }

    private var authorizationHeader: [String: String] {
        guard let token = tokenProvider(), !token.isEmpty else {
            return [:]
        }

        return ["Authorization": "Bearer \(token)"]
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200 ..< 300 ~= httpResponse.statusCode else {
            let apiError = try? JSONDecoder.apiDecoder.decode(APIErrorResponse.self, from: data)
            throw NetworkError.invalidStatusCode(httpResponse.statusCode, apiError)
        }
    }
}
