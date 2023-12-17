//
//  SettingList.swift
//  Mobbie
//
//  Created by yeoni on 12/17/23.
//

import Foundation

class SettingList {
    
    static let shared = SettingList()
    private init() { }
    
    var settingList: [String] = [
    "프로필 보기",
    "좋아한 글 모아보기",
    "로그아웃",
    "회원 탈퇴"
    ]
}
