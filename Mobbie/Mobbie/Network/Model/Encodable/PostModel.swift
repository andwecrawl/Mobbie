//
//  PostModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import Foundation

struct PostModel: Encodable {
    let content: String
    var file: Data?
    let product_id: String
    // 이외에도 content1/2/3/4/5
}
