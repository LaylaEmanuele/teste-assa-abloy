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
    @Published var searchText = ""
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
        await fetchDoors(authToken: authToken, query: searchText, forceRefresh: forceRefresh)
    }

    func searchDoors(authToken: String?) async {
        await fetchDoors(authToken: authToken, query: searchText, forceRefresh: true)
    }

    private func fetchDoors(authToken: String?, query: String, forceRefresh: Bool) async {
        guard !isLoading else {
            return
        }

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard forceRefresh || !hasLoaded || !trimmedQuery.isEmpty else {
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
            let response: DoorsResponse
            if trimmedQuery.isEmpty {
                response = try await doorsService.fetchDoors(authToken: authToken, page: 0, size: 20)
                hasLoaded = true
            } else {
                response = try await doorsService.findDoors(authToken: authToken, name: trimmedQuery, page: 0, size: 20)
            }

            doors = response.content.map(\.presentation)
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
