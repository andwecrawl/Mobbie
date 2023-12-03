//
//  PostResponse.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import Foundation

struct PostResponse: Decodable {
    var _id: String
    var creator: User
    var time: String
    var content: String
    var likes: [String]
    var image: [String]
    var hashTags: [String]
    var comments: [Comment]
}

struct Comment: Decodable {
    var _id: String
    var creator: User
    var time: String
    var content: String
}

struct User: Decodable {
    var _id: String
    var nick: String
    var profile: String
}

struct DeletePostResponse {
    var _id: String
}
