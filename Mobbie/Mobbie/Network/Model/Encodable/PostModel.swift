//
//  PostModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import Foundation

struct PostModel: Encodable {
    let content: String
    var file: [Data]? = nil
    let productID: String = "MobbieFeed"
    let nickname: String = UserDefaultsHelper.shared.nickname
    let commentUsers: String = ""
    // 이외에도 content1/2/3/4/5
    
    enum CodingKeys: String, CodingKey {
        case content
        case file
        case productID = "product_id"
        case nickname = "content1"
        case commentUsers = "content2"
    }
}

struct CommentModel: Encodable {
    let content: String
}
