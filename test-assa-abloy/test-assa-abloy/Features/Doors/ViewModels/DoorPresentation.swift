//
//  DoorPresentation.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

struct DoorPresentation: Hashable, Identifiable {
    let id: Int
    let name: String
    let address: String
    let batteryLevel: Int

    static let sample = DoorPresentation(
        id: 1,
        name: "Museu do Ipiranga",
        address: "Parque da Independência, São Paulo - SP",
        batteryLevel: 87
    )
}
