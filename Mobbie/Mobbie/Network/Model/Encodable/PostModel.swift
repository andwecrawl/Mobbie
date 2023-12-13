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
    let product_id: String = "MobbieFeed"
    // 이외에도 content1/2/3/4/5
}
