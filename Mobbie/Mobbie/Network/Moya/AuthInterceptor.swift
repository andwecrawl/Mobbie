//
//  Interceptor.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/29.
//

import UIKit
import Alamofire
import Moya

final class AuthInterceptor: RequestInterceptor {
    
    static let shared = AuthInterceptor()

    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("adator 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
           print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419
           else {
               completion(.doNotRetryWithError(error))
               return
           }

           // statusCode == 401 || 419
        MoyaAPIManager.shared.fetchInSignProgress(.refreshAccessToken, type: TokenResponse.self)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    // 토큰 재발급 성공 -> 갈아끼우기
                    UserDefaultsHelper.shared.accessToken = result.token
                    
                    completion(.retry)
                case .failure(let error):
                    // 갱신 실패 -> 로그인 화면으로 전환
                    completion(.doNotRetryWithError(error))
                    
                    // 이전에 쌓였던 화면이 clear => 새로 진입
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let SceneDelegate = windowScene?.delegate as? SceneDelegate
                    
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    
                    SceneDelegate?.window?.rootViewController = nav
                    SceneDelegate?.window?.makeKeyAndVisible()
                    
                }
            }
            .dispose()
        
       }
}
