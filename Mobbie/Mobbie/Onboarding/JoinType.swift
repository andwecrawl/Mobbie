//
//  JoinType.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/18.
//

import Foundation

enum JoinType: String {
    case email = "이메일을 입력해 주세요."
    case password = "비밀번호를 입력해 주세요."
    case phoneNumber = "핸드폰 번호를 입력해 주세요."
    case end = "환영합니다!"
    
    var requirement: String {
        switch self {
        case .email:
            return "email은 추후 ID로 사용돼요!"
        case .password:
            return "대소문자와 숫자를 포함하여 6자 이상 작성해 주세요!"
        case .end:
            return "00에서 즐거운 시간을 보내세요 🔥"
        case .phoneNumber:
            return "핸드폰 번호를 입력해 주세요!"
        }
    }
    
    var placeholder: String {
        switch self {
        case .email:
            return "ex) aaa123@ssacmail.com"
        case .password:
            return "비밀번호를 입력해 주세요!"
        case .end:
            return ""
        case .phoneNumber:
            return "ex) 010-1234-5678"
        }
    }
}
