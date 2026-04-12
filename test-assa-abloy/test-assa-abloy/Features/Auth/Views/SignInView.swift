//
//  SignInView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var session: AppSession
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        List {
            Section("Acesso") {
                Text("Entre com sua conta para acessar a lista de portas.")
                    .foregroundStyle(.secondary)
            }

            Section {
                Button("Continuar") {
                    session.signIn()
                    router.popToRoot()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Entrar")
    }
}
