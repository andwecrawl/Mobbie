//
//  WelcomeViewModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/28.
//

import Foundation
import RxSwift
import RxCocoa

class WelcomeViewModel: ViewModel {
    
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
                print(self.newInfo)
                return MoyaAPIManager.shared.fetchInSignProgress(.Login(email: input.userInfo.id, password: input.userInfo.password), type: LoginResponse.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print("===== login Success!!: \(result.token), \(result.refreshToken)")
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
