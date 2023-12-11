//
//  WelcomeViewModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/28.
//

import Foundation
import RxSwift
import RxCocoa

final class WelcomeViewModel: ViewModel {
    
    let newInfo: BehaviorSubject<UserInfo> = BehaviorSubject(value: UserInfo(id: "", password: "", phoneNumber: ""))
    var disposeBag = DisposeBag()
    
    struct Input {
        let tap: ControlEvent<Void>
        var userInfo: UserInfo
    }
    
    struct Output {
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output? {
        newInfo.onNext(input.userInfo)
        
        input.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                let model = LoginData(email: input.userInfo.id, password: input.userInfo.password)
                return MoyaAPIManager.shared.fetchInSignProgress(.login(model: model), type: LoginResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print("===== login Success!!: \(result.token), \(result.refreshToken)")
                    UserDefaultsHelper.shared.accessToken = result.token
                    UserDefaultsHelper.shared.refreshToken = result.refreshToken
                    UserDefaultsHelper.shared.userID = result._id
                case .failure(let error):
                    "======= error message: \(error.localizedDescription)"
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            tap: input.tap
        )
    }
}
