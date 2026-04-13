//
//  SignUpView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignUpViewModel()

    var body: some View {
        Form {
            Section("Dados pessoais") {
                TextField("Nome", text: $viewModel.firstName)
                    .textContentType(.givenName)

                TextField("Sobrenome", text: $viewModel.lastName)
                    .textContentType(.familyName)
            }

            Section("Credenciais") {
                TextField("E-mail", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()

                SecureField("Senha", text: $viewModel.password)
                    .textContentType(.newPassword)
            }

            if let successMessage = viewModel.successMessage {
                Section {
                    Text(successMessage)
                        .foregroundStyle(.green)
                }
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
                        let didSucceed = await viewModel.signUp()
                        guard didSucceed else {
                            return
                        }

                        dismiss()
                    }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("Criar conta")
                        }
                        Spacer()
                    }
                }
                .disabled(viewModel.isLoading)
            }
        }
        .navigationTitle("Criar conta")
    }
}
