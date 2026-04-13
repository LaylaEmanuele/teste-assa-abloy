//
//  APIErrorResponse.swift
//  test-assa-abloy
//
//  Created by Layla Emanuele on 12/04/26.
//

import Foundation

struct APIErrorResponse: Decodable, Error {
    let code: String
    let description: String
    let fieldErrors: [APIFieldError]
}

struct APIFieldError: Decodable, Hashable {
    let field: String
    let message: String
}
