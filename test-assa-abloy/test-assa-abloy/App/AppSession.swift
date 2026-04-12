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

    func restoreSession() {
        isAuthenticated = false
    }

    func signIn() {
        isAuthenticated = true
    }

    func signOut() {
        isAuthenticated = false
    }
}
