//
//  AuthLandingView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct AuthLandingView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                Text("ASSA ABLOY")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text("Mobile Challenge")
                    .font(.largeTitle.weight(.bold))

                Text("Base inicial em SwiftUI com NavigationStack e arquitetura preparada para MVVM.")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                Button("Entrar") {
                    router.push(.signIn)
                }
                .buttonStyle(.borderedProminent)

                Button("Criar conta") {
                    router.push(.signUp)
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding(24)
        .navigationTitle("Acesso")
    }
}
