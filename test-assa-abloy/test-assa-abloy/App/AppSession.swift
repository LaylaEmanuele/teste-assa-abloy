//
//  AppSession.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation
import Combine

@MainActor
final class AppSession: ObservableObject {
    @Published private(set) var isAuthenticated = false
    @Published private(set) var token: String?

    private let sessionStore: SessionStoring

    init(sessionStore: SessionStoring) {
        self.sessionStore = sessionStore
    }

    func restoreSession() {
        do {
            let storedToken = try sessionStore.fetchToken()
            token = storedToken
            isAuthenticated = storedToken?.isEmpty == false
        } catch {
            token = nil
            isAuthenticated = false
        }
    }

    func signIn() {
        startSession(with: UUID().uuidString)
    }

    func startSession(with token: String) {
        do {
            try sessionStore.saveToken(token)
            self.token = token
            isAuthenticated = true
        } catch {
            self.token = nil
            isAuthenticated = false
        }
    }

    func signOut() {
        do {
            try sessionStore.clearToken()
        } catch {
            // Keep local state consistent even if deletion fails.
        }

        token = nil
        isAuthenticated = false
    }
}
