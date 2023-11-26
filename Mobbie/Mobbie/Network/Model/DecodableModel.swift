//
//  DecodableModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/17.
//

import Foundation

struct JoinResponse: Decodable {
    let email: String
    let password: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case email = "_id"
        case password
        case nickname = "nick"
    }
}

struct LoginResponse: Decodable {
    let email: String
    let password: String
}

struct ValidationResponse: Decodable {
    let message: String
}

struct ErrorResponse: Decodable {
    let message: String
}
