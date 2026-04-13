//
//  SessionStore.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

protocol SessionStoring {
    func fetchToken() throws -> String?
    func saveToken(_ token: String) throws
    func clearToken() throws
}

struct SessionStore: SessionStoring {
    private enum Keys {
        static let authToken = "auth.token"
    }

    private let keychain: KeychainStoring

    init(keychain: KeychainStoring = KeychainService()) {
        self.keychain = keychain
    }

    func fetchToken() throws -> String? {
        guard let data = try keychain.read(for: Keys.authToken) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func saveToken(_ token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        try keychain.save(data, for: Keys.authToken)
    }

    func clearToken() throws {
        try keychain.delete(for: Keys.authToken)
    }
}
