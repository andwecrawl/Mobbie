//
//  DecodableModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/17.
//

import Foundation

struct JoinResponse: Decodable {
    let id: String
    let email: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case nickname = "nick"
    }
}

struct LoginResponse: Decodable {
    let _id: String
    let token: String
    let refreshToken: String
}

struct TokenResponse: Decodable {
    let token: String
}

struct ValidationResponse: Decodable {
    let message: String
}

struct ErrorResponse: Decodable {
    let message: String
}
