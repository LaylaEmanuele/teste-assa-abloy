//
//  APIRequest.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

struct APIRequest {
    let path: String
    let method: HTTPMethod
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var body: Data?

    init(
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }

    init<Body: Encodable>(
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Body,
        encoder: JSONEncoder = JSONEncoder.apiEncoder
    ) throws {
        do {
            self.path = path
            self.method = method
            self.queryItems = queryItems
            self.body = try encoder.encode(body)
            self.headers = headers.merging(["Content-Type": "application/json"]) { _, new in new }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
