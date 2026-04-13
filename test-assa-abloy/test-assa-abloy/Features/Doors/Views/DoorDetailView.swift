//
//  DoorDetailView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct DoorDetailView: View {
    let door: DoorPresentation

    var body: some View {
        List {
            Section("Informacoes") {
                LabeledContent("Nome", value: door.name)
                LabeledContent("Serial", value: door.serial)
                LabeledContent("MAC", value: door.lockMac)
                LabeledContent("Bateria", value: "\(door.batteryLevel)%")
            }

            Section("Localizacao") {
                LabeledContent("Endereco", value: door.address)
                LabeledContent("Latitude", value: String(format: "%.4f", door.latitude))
                LabeledContent("Longitude", value: String(format: "%.4f", door.longitude))
            }
        }
        .navigationTitle("Detalhe")
    }
}
