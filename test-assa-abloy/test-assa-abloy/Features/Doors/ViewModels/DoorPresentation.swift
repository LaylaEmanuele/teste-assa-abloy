//
//  DoorPresentation.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

struct DoorPresentation: Hashable, Identifiable {
    let id: Int
    let serial: String
    let lockMac: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let batteryLevel: Int
}

extension DoorDTO {
    var presentation: DoorPresentation {
        DoorPresentation(
            id: id,
            serial: serial,
            lockMac: lockMac,
            name: name,
            address: address,
            latitude: latitude,
            longitude: longitude,
            batteryLevel: battery
        )
    }
}
