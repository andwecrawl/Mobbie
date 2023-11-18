//
//  LSLPNetwork.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation
import Moya

enum LSLPNetwork {
    case signUp(model: Model)
    case Login(email: String, password: String)
    case emailValidation(email: String)
}

extension LSLPNetwork: TargetType {
    var baseURL: URL {
        return URL(string: APIKeyURL.baseURL.rawValue)!
    }
    
    var path: String {
        switch self {
        case .signUp(_):
            return "join"
        case .Login(_, _):
            return "login"
        case .emailValidation(_):
            return "validation/email"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
            
        case .signUp(let model):
            return .requestJSONEncodable(model)
            
        case .Login(let email, let password):
            let data = LoginData(email: email, password: password)
            return .requestJSONEncodable(data)
            
        case .emailValidation(email: let email):
            let data = EmailValidation(email: email)
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SesacKey": "b44Glvau1w"
        ]
    }
    
    
}
