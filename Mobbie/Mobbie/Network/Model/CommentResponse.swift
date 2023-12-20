//
//  CommentResponse.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import Foundation

struct Comment: Decodable {
    var _id: String
    var creator: User
    var time: String
    var content: String
}

struct DeleteCommentResponse: Decodable {
    var postID: String
}
