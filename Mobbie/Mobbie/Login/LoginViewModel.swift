//
//  LoginViewModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/20.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModel {
    
    var model = LoginData(email: "", password: "")
    var disposeBag = DisposeBag()
    
    struct Input {
        let loginButtonTapped: ControlEvent<Void>
        let signUpButtonTapped: ControlEvent<Void>
        let id: ControlProperty<String>
        let password: ControlProperty<String>
    }
    
    struct Output {
        let loginButtonTapped: ControlEvent<Void>
        let signUpButtonTapped: ControlEvent<Void>
        let canTryLogin: BehaviorSubject<Bool>
        let canLogin: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output? {
        
        let isValidID = BehaviorSubject(value: false)
        let isValidPassword = BehaviorSubject(value: false)
        let canTryLogin = BehaviorSubject(value: false)
        let canLogin = BehaviorSubject(value: false)
        
        input.id
            .map {
                self.model.email = $0
                return ($0.range(of: RegexType.email.rawValue, options: .regularExpression) != nil)
            }
            .bind(to: isValidID)
            .disposed(by: disposeBag)
        
        input.password
            .map {
                self.model.password = $0
                return ($0.range(of: RegexType.password.rawValue, options: .regularExpression) != nil)
            }
            .bind(to: isValidPassword)
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(isValidID, isValidPassword)
            .map { $0.0 && $0.1 }
            .bind(to: canTryLogin)
            .disposed(by: disposeBag)
        
        
        input.loginButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(canTryLogin)
            .filter { $0 }
            .flatMap { _ in
                let model = LoginData(email: self.model.email, password: self.model.password)
                return MoyaAPIManager.shared.fetchInSignProgress(.login(model: model), type: LoginResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print("===== login Success!!: \(result.token), \(result.refreshToken)")
                    UserDefaultsHelper.shared.accessToken = result.token
                    UserDefaultsHelper.shared.refreshToken = result.refreshToken
                    canLogin.onNext(true)
                case .failure(let error):
                    "======= error message: \(error.localizedDescription)"
                    canLogin.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            loginButtonTapped: input.loginButtonTapped,
            signUpButtonTapped: input.signUpButtonTapped,
            canTryLogin: canTryLogin,
            canLogin: canLogin
        )
    }
}

