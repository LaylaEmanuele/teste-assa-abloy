//
//  SignUpView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        List {
            Section("Cadastro") {
                Text("Crie sua conta para começar a usar o aplicativo.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Criar conta")
    }
}
