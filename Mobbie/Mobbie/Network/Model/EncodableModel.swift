//
//  EncodableModel.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation

struct Model: Encodable {
    let email: String
    let password: String
    let phoneNumber: String
}

struct LoginData: Encodable {
    let email: String
    let password: String
}

struct EmailValidation: Encodable {
    let email: String
}
