//
//  test_assa_abloyApp.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

@main
struct test_assa_abloyApp: App {
    @StateObject private var session: AppSession
    @StateObject private var router = AppRouter()

    init() {
        _session = StateObject(wrappedValue: AppSession(sessionStore: SessionStore()))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .environmentObject(router)
                .task {
                    session.restoreSession()
                }
        }
    }
}
