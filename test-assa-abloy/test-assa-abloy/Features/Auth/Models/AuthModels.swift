//
//  AuthModels.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

struct SignInRequest: Encodable {
    let email: String
    let password: String
}

struct SignInResponse: Decodable, Sendable {
    let token: String
}

struct SignUpRequest: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct SignUpResponse: Decodable, Sendable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
}
