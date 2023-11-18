//
//  DecodableModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/17.
//

import Foundation

struct ModelResponse: Decodable {
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

struct ErrorMessages: Decodable {
    let message: String
}
