//
//  LSLPNetwork.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation
import Moya

enum MoyaNetwork {
    // login
    case signUp(model: SignUpData)
    case login(model: LoginData)
    case emailValidation(model: ValidationData)
    
    // refresh
    case refreshAccessToken
    
    // 게시글
    case writePost
    case fetchPost
    case modifiyPost(postID: String)
    case deletePost(postID: String)
    
    // 댓글
    case writeComment(postID: String, content: String)
    case modifiyComment(postID: String, commentID: String, content: String)
}

extension MoyaNetwork: TargetType {
    var baseURL: URL {
        return URL(string: APIKeyURL.baseURL.rawValue)!
    }
    
    var path: String {
        switch self {
        case .signUp(_):
            return "join"
        case .login(_):
            return "login"
        case .emailValidation(_):
            return "validation/email"
        case .refreshAccessToken:
            return "refresh"
        case .writePost, .fetchPost:
            return "post"
        case .modifiyPost(let postID), .deletePost(let postID):
            return "post/\(postID)"
        case .writeComment(let postID, _):
            return "post/\(postID)/comment"
        case .modifiyComment(let postID, let commentID, _):
            return "post/\(postID)/comment/\(commentID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .login, .emailValidation, .writePost, .writeComment:
            return .post
        case .refreshAccessToken, .fetchPost:
            return .get
        case .modifiyPost, .modifiyComment:
            return .put
        case .deletePost:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let model):
            return .requestJSONEncodable(model)
            
        case .login(let model):
            return .requestJSONEncodable(model)
            
        case .emailValidation(let model):
            return .requestJSONEncodable(model)
            
        case .refreshAccessToken:
            return .requestPlain
        case .writePost:
            <#code#>
        case .fetchPost:
            let params: [String: String]
        case .modifiyPost:
            <#code#>
        case .deletePost:
            <#code#>
        case .writeComment(_, let content), .modifiyComment(_, _, let content):
            return .requestJSONEncodable(content)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp, .login, .emailValidation:
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
        case .writePost, .modifiyPost:
            [
                "Authorization": UserDefaultsHelper.shared.accessToken,
                "Content-Type": "multipart/form-data",
                "SesacKey": APIKeyURL.APIKey.rawValue
            ]
        case .fetchPost, .deletePost:
            [
                "Authorization": UserDefaultsHelper.shared.accessToken,
                "SesacKey": APIKeyURL.APIKey.rawValue
            ]
        case .writeComment, .modifiyComment:
            [
                "Authorization": UserDefaultsHelper.shared.accessToken,
                "Content-Type": "application/json",
                "SesacKey": APIKeyURL.APIKey.rawValue
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
