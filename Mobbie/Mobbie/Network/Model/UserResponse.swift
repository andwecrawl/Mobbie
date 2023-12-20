//
//  UserResponse.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import Foundation

struct User: Decodable {
    var _id: String
    var nick: String
}

struct Profile: Decodable {
    var posts: [String]
    var _id: String
}
