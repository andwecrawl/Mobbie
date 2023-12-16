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
    case writePost(model: PostModel)
    case fetchPost(nextCursor: String)
    case fetchSpecificPost(postID: String)
    case modifiyPost(postID: String, model: PostModel)
    case deletePost(postID: String)
    
    // 댓글
    case writeComment(postID: String, content: String)
    case modifiyComment(postID: String, commentID: String, content: String)
    
    // 좋아요
    case liked(postID: String)
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
        case .fetchSpecificPost(let postID):
            return "post/\(postID)"
        case .modifiyPost(let postID, _), .deletePost(let postID):
            return "post/\(postID)"
        case .writeComment(let postID, _):
            return "post/\(postID)/comment"
        case .modifiyComment(let postID, let commentID, _):
            return "post/\(postID)/comment/\(commentID)"
        case .liked(postID: let postID):
            return "post/like/\(postID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .login, .emailValidation, .writePost, .writeComment, .liked:
            return .post
        case .refreshAccessToken, .fetchPost, .fetchSpecificPost:
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
            
            // refresh token
        case .refreshAccessToken:
            return .requestPlain
            
            // 포스트 작성
        case .writePost(let model), .modifiyPost(_, let model):
            let productID = MultipartFormData(provider: .data(model.productID.data(using: .utf8)!), name: "product_id")
            let content = MultipartFormData(provider: .data(model.content.data(using: .utf8)!), name: "content")
            
            var multipartData: [MultipartFormData] = [productID, content]
            
            if let images = model.file {
                var data: [MultipartFormData] = []
                images.forEach { data.append(MultipartFormData(provider: .data($0), name: "file", fileName: "\($0).jpg", mimeType: "image/jpg")) }
                multipartData.append(contentsOf: data)
            }
            
            return .uploadMultipart(multipartData)
            
        case .fetchPost(let cursor):
            let params: [String: String] = [
                "next": cursor,
                "limit": "20",
                "product_id": "MobbieFeed"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString )
            
        case .writeComment(_, let content):
            let model = CommentModel(content: content)
            return .requestJSONEncodable(model)
        default: return .requestPlain
            
//        case .modifiyComment(_, _, let content):
//            return .requestJSONEncodable(content)
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
        case .fetchPost, .fetchSpecificPost, .deletePost, .liked:
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
        switch self {
        case .signUp, .login, .emailValidation:
            return .none
        default:
            return .successCodes
        }
    }
}
