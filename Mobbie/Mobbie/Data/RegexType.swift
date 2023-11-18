//
//  String+.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/10.
//

import Foundation


enum RegexType: String {
    case email = #"^([a-zA-Z0-9._-])+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,20}$"#
    case password = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}$"#
    case phoneNumber = #"[0-9]{3}\-[0-9]{4}\-[0-9]{4}"#
}
