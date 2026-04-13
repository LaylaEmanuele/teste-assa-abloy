//
//  DoorsHomeViewModel.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation
import Combine

@MainActor
final class DoorsHomeViewModel: ObservableObject {
    @Published private(set) var doors: [DoorPresentation] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let doorsService: DoorsServicing
    private var hasLoaded = false

    init(doorsService: DoorsServicing) {
        self.doorsService = doorsService
    }

    init() {
        self.doorsService = DoorsService()
    }

    func loadDoors(authToken: String?, forceRefresh: Bool = false) async {
        guard !isLoading else {
            return
        }

        guard forceRefresh || !hasLoaded else {
            return
        }

        guard let authToken, !authToken.isEmpty else {
            errorMessage = "Sua sessao expirou. Entre novamente para continuar."
            doors = []
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await doorsService.fetchDoors(authToken: authToken, page: 0, size: 20)
            doors = response.content.map(\.presentation)
            hasLoaded = true
            errorMessage = nil
        } catch {
            if shouldIgnore(error) {
                errorMessage = nil
                return
            }

            doors = []
            errorMessage = Self.message(for: error)
        }
    }

    private func shouldIgnore(_ error: Error) -> Bool {
        if error is CancellationError {
            return true
        }

        if case NetworkError.cancelled = error {
            return true
        }

        return false
    }

    private static func message(for error: Error) -> String {
        if error is CancellationError {
            return ""
        }

        if case NetworkError.cancelled = error {
            return ""
        }

        if let networkError = error as? NetworkError {
            return networkError.errorDescription ?? "Nao foi possivel carregar as portas agora."
        }

        if let apiError = error as? APIErrorResponse {
            return apiError.description
        }

        return error.localizedDescription
    }
}
