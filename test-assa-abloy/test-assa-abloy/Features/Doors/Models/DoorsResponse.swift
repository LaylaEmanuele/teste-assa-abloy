//
//  DoorsResponse.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

struct DoorsResponse: Decodable {
    let content: [DoorDTO]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let last: Bool
}

struct DoorDTO: Decodable {
    let id: Int
    let serial: String
    let lockMac: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let battery: Int
}
