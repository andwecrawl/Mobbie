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
    let nick = "\(UUID())"
    let phoneNum: String
}

struct LoginData: Encodable {
    var email: String
    var password: String
}

struct ValidationData: Encodable {
    let email: String
}
