//
//  ProfileSegmentData.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import Foundation


struct ProfileSegmentData {
    var title: String
    var isSelected: Bool
}

class ProfileSegmentDataList {
    
    static let shared = ProfileSegmentDataList()
    
    private init() { }
    
    
    var list = [
    ProfileSegmentData(title: "내가 쓴 글", isSelected: true),
    ProfileSegmentData(title: "미디어", isSelected: false),
    ProfileSegmentData(title: "좋아요한 글", isSelected: false)
    ]
    
    func segmentedDataTapped(index: Int) {
        for index in list.indices {
            list[index].isSelected = false
        }
        list[index].isSelected = true
    }
}
