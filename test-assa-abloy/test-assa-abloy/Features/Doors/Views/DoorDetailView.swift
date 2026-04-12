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
            LabeledContent("Nome", value: door.name)
            LabeledContent("Endereço", value: door.address)
            LabeledContent("Bateria", value: "\(door.batteryLevel)%")
        }
        .navigationTitle("Detalhe")
    }
}
