//
//  SignInView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var session: AppSession
    @StateObject private var viewModel = SignInViewModel()

    var body: some View {
        Form {
            Section {
                TextField("E-mail", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()

                SecureField("Senha", text: $viewModel.password)
                    .textContentType(.password)
            } header: {
                Text("Acesso")
            } footer: {
                Text("Entre com sua conta para acessar a lista de portas.")
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button {
                    Task {
                        guard let token = await viewModel.signIn() else {
                            return
                        }

                        session.startSession(with: token)
                    }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("Entrar")
                        }
                        Spacer()
                    }
                }
                .disabled(viewModel.isLoading)
            }
        }
        .navigationTitle("Entrar")
    }
}
