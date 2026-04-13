//
//  DoorsHomeView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct DoorsHomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var session: AppSession
    @StateObject private var viewModel = DoorsHomeViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.doors.isEmpty {
                ProgressView("Carregando portas...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                        Section {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                        }
                    }

                    if viewModel.doors.isEmpty && !viewModel.isLoading {
                        Section {
                            Text("Nenhuma porta encontrada.")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Section("Portas") {
                            ForEach(viewModel.doors) { door in
                                Button {
                                    router.push(.doorDetails(door))
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Text(door.name)
                                                .font(.headline)
                                                .foregroundStyle(.primary)

                                            Spacer()

                                            Text("\(door.batteryLevel)%")
                                                .font(.subheadline.weight(.semibold))
                                                .foregroundStyle(batteryColor(for: door.batteryLevel))
                                        }

                                        Text(door.address)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button("Ver eventos") {
                                        router.push(.events(door))
                                    }
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.loadDoors(authToken: session.token, forceRefresh: true)
                }
            }
        }
        .navigationTitle("Portas")
        .searchable(text: $viewModel.searchText, prompt: "Buscar por nome")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Sair") {
                    session.signOut()
                    router.popToRoot()
                }
            }
        }
        .task(id: session.token) {
            await viewModel.loadDoors(authToken: session.token)
        }
        .task(id: viewModel.searchText) {
            try? await Task.sleep(for: .milliseconds(350))
            guard !Task.isCancelled else {
                return
            }
            await viewModel.searchDoors(authToken: session.token)
        }
        .onAppear {
            guard viewModel.doors.isEmpty else {
                return
            }

            Task {
                try? await Task.sleep(for: .milliseconds(350))
                await viewModel.loadDoors(authToken: session.token, forceRefresh: true)
            }
        }
    }

    private func batteryColor(for level: Int) -> Color {
        switch level {
        case ..<20:
            return .red
        case ..<50:
            return .orange
        default:
            return .green
        }
    }
}
