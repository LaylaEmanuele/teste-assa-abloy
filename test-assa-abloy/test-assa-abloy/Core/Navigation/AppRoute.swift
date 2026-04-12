//
//  AppRoute.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

enum AppRoute: Hashable {
    case signIn
    case signUp
    case doors
    case doorDetails(DoorPresentation)
    case events(DoorPresentation)
}
