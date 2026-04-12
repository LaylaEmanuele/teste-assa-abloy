//
//  DoorEventsView.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import SwiftUI

struct DoorEventsView: View {
    let door: DoorPresentation

    var body: some View {
        List {
            Section("Porta") {
                Text(door.name)
                Text(door.address)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Eventos")
    }
}
