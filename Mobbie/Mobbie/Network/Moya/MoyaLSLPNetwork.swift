//
//  LSLPNetwork.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation
import Moya

enum MoyaNetwork {
    case signUp(model: SignUpData)
    case Login(model: LoginData)
    case emailValidation(model: ValidationData)
    case refreshAccessToken
}

extension MoyaNetwork: TargetType {
    var baseURL: URL {
        return URL(string: APIKeyURL.baseURL.rawValue)!
    }
    
    var path: String {
        switch self {
        case .signUp(_):
            return "join"
        case .Login(_):
            return "login"
        case .emailValidation(_):
            return "validation/email"
        case .refreshAccessToken:
            return "refresh"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
            
        case .signUp(let model):
            return .requestJSONEncodable(model)
            
        case .Login(let model):
            return .requestJSONEncodable(model)
            
        case .emailValidation(let email):
            return .requestJSONEncodable(email)
            
        case .refreshAccessToken:
            return .requestPlain
        }
    }
    
    var content: [String : String]? {
        [
            "Content-Type": "application/json",
            "SesacKey": APIKeyURL.APIKey.rawValue
        ]
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp, .Login, .emailValidation:
            [
                "Content-Type": "application/json",
                "SesacKey": APIKeyURL.APIKey.rawValue
            ]
        case .refreshAccessToken:
            [
                "Authorization": UserDefaultsHelper.shared.accessToken,
                "SesacKey": APIKeyURL.APIKey.rawValue,
                "Refresh": UserDefaultsHelper.shared.refreshToken
            ]
        }
    }
    
    
}
