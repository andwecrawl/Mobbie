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
    
    var accessToken: String {
        get {
            return userDefaults.string(forKey: "accessToken") ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: "accessToken")
        }
    }
    
    var refreshToken: String {
        get {
            return userDefaults.string(forKey: "refreshToken") ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: "refreshToken")
        }
    }
}
