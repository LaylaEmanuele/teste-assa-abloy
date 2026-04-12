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

    private let sampleDoor = DoorPresentation.sample

    var body: some View {
        List {
            Section("Boas-vindas") {
                Text("Selecione uma porta para visualizar os detalhes ou acessar os eventos.")
                    .foregroundStyle(.secondary)
            }

            Section("Fluxo de navegação") {
                Button(sampleDoor.name) {
                    router.push(.doorDetails(sampleDoor))
                }

                Button("Ver eventos da porta") {
                    router.push(.events(sampleDoor))
                }
            }
        }
        .navigationTitle("Portas")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Sair") {
                    session.signOut()
                    router.popToRoot()
                }
            }
        }
    }
}
