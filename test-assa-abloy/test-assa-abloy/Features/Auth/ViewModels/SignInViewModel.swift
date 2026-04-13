//
//  SignInViewModel.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation
import Combine

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthServicing

    init(authService: AuthServicing) {
        self.authService = authService
    }

    init() {
        self.authService = AuthService()
    }

    func signIn() async -> String? {
        errorMessage = nil

        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            errorMessage = "Preencha e-mail e senha para continuar."
            return nil
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await authService.signIn(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            return response.token
        } catch {
            errorMessage = Self.message(for: error)
            return nil
        }
    }

    private static func message(for error: Error) -> String {
        if let networkError = error as? NetworkError {
            return networkError.errorDescription ?? "Nao foi possivel entrar agora."
        }

        if let apiError = error as? APIErrorResponse {
            return apiError.description
        }

        return error.localizedDescription
    }
}
