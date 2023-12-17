//
//  Interceptor.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/29.
//

import UIKit
import RxSwift
import Alamofire
import Moya

final class AuthInterceptor: RequestInterceptor, TransitionProtocol {
    
    static let shared = AuthInterceptor()

    private init() {}
    
    var disposeBag = DisposeBag()
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
           print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 || response.statusCode == 418
           else {
            print("error?")
            completion(.doNotRetryWithError(error))
               return
           }
        
        if response.statusCode == 418 {
            DispatchQueue.main.async {
                self.transitionTo(LoginViewController())
            }
            return
        }
        
        let task = Observable.just(())
        
        task
            .observe(on: MainScheduler.asyncInstance)
            .flatMap{ MoyaAPIManager.shared.fetchInSignProgress(.refreshAccessToken, type: TokenResponse.self) }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    // 토큰 재발급 성공 -> 갈아끼우기
                    print(UserDefaultsHelper.shared.accessToken)
                    print(result.token)
                    UserDefaultsHelper.shared.accessToken = result.token
                    
                    print(UserDefaultsHelper.shared.accessToken)
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
            .disposed(by: disposeBag)
        
       }
}
