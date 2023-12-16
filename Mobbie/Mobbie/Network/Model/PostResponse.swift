//
//  PostResponse.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import Foundation

struct PostResponse: Decodable {
    let data: [Post]
    let nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

struct Post: Decodable {
    var _id: String
    var creator: User
    var time: String
    var content: String?
    var likes: [String]
    var image: [String]
    var hashTags: [String]
    var comments: [Comment]
    var productID: String?
    var nickname: String?
    var commentUser: String
    
    var commentNicknames: [String] {
        commentUser.components(separatedBy: ", ")
    }
    
    enum CodingKeys: String, CodingKey {
        case _id, creator, time, content, likes, image
        case hashTags, comments, productID
        case nickname = "content1"
        case commentUser = "content2"
    }
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
}

struct DeletePostResponse: Decodable {
    var _id: String
}

struct likedResponse: Decodable {
    var isSuccess: Bool
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "like_status"
    }
}
