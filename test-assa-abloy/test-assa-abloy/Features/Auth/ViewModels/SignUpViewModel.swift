//
//  SignUpViewModel.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let authService: AuthServicing

    init(authService: AuthServicing) {
        self.authService = authService
    }

    init() {
        self.authService = AuthService()
    }

    func signUp() async -> Bool {
        errorMessage = nil
        successMessage = nil

        guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            errorMessage = "Preencha todos os campos para continuar."
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await authService.signUp(
                firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            successMessage = "Cadastro realizado com sucesso. Agora voce pode entrar."
            password = ""
            return true
        } catch {
            errorMessage = Self.message(for: error)
            return false
        }
    }

    private static func message(for error: Error) -> String {
        if let networkError = error as? NetworkError {
            return networkError.errorDescription ?? "Nao foi possivel concluir o cadastro agora."
        }

        if let apiError = error as? APIErrorResponse {
            return apiError.description
        }

        return error.localizedDescription
    }
}
