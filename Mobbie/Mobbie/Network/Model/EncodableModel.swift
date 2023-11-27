//
//  EncodableModel.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation

struct SignUpData: Encodable {
    let email: String
    let password: String
    let nick = UUID()
    let phoneNum: String
}

struct LoginData: Encodable {
    let email: String
    let password: String
}

struct EmailValidation: Encodable {
    let email: String
}
