//
//  AuthService.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

protocol AuthServicing {
    func signIn(email: String, password: String) async throws -> SignInResponse
    func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> SignUpResponse
}

@MainActor
struct AuthService: AuthServicing {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    init() {
        self.apiClient = URLSessionAPIClient()
    }

    func signIn(email: String, password: String) async throws -> SignInResponse {
        let request = try APIRequest(
            path: "/users/signin",
            method: .post,
            body: SignInRequest(email: email, password: password)
        )

        return try await apiClient.send(request, as: SignInResponse.self)
    }

    func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> SignUpResponse {
        let request = try APIRequest(
            path: "/users/signup",
            method: .post,
            body: SignUpRequest(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )
        )

        return try await apiClient.send(request, as: SignUpResponse.self)
    }
}
