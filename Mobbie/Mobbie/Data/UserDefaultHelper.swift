//
//  UserDefaultHelper.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/09.
//

import Foundation

class UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()
    
    private init() { }
    
    private let userDefaults = UserDefaults.standard
    
    var haveBeenBefore: Bool {
        get {
            return userDefaults.bool(forKey: "haveBeenBefore")
        }
        set {
            userDefaults.set(newValue, forKey: "haveBeenBefore")
        }
    }
    
    
}
