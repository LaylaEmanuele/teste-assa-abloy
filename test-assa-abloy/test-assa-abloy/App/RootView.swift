//
//  RootView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var session: AppSession
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if session.isAuthenticated {
                    DoorsHomeView()
                } else {
                    AuthLandingView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .signIn:
                    SignInView()
                case .signUp:
                    SignUpView()
                case .doors:
                    DoorsHomeView()
                case let .doorDetails(door):
                    DoorDetailView(door: door)
                case let .events(door):
                    DoorEventsView(door: door)
                }
            }
        }
        .onChange(of: session.isAuthenticated) { _, _ in
            router.popToRoot()
        }
    }
}
