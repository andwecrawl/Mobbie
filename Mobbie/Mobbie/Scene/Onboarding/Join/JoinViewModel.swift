//
//  JoinViewModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/10.
//

import Foundation

import RxSwift
import RxCocoa

final class JoinViewModel: ViewModel {
    
    var newInfo = UserInfo(id: "", password: "", phoneNumber: "")
    var joinType: JoinType?
    var disposeBag = DisposeBag()
    
    var completionHandler: ((String) -> ())?
    
    struct Input {
        let userInput: ControlProperty<String>
        var userInfo: UserInfo
        let tap: ControlEvent<Void>
        let validationButtonTap: ControlEvent<Void>
        let validationButtonIsEnabled: Binder<Bool>
        var nextButtonIsEnabled: Binder<Bool>
    }
    
    struct Output {
        let isValid: BehaviorSubject<Bool>
        let isValidToNext: BehaviorSubject<Bool>
        let tap: ControlEvent<Void>
        let userInfo: BehaviorSubject<UserInfo>
        let text: BehaviorSubject<String>
    }
    
    func transform(input: Input) -> Output? {
        
        guard let joinType else { return nil }
        
        let isValidText = BehaviorSubject(value: false)
        let isValidToNext = BehaviorSubject(value: false)
        let isFilled = BehaviorSubject(value: false)
        let text = BehaviorSubject<String>(value: "")
        let subjectInfo = BehaviorSubject(value: input.userInfo)
        
        isValidText
            .bind(with: self, onNext: { owner, value in
                if owner.joinType == .email {
                    input.validationButtonIsEnabled.onNext(value)
                } else {
                    isValidToNext.onNext(value)
                }
            })
            .disposed(by: disposeBag)
        
        isValidToNext
            .bind(with: self) { owenr, value in
                input.nextButtonIsEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
        input.userInput
            .bind(with: self) { owner, value in
                let result = joinType == .phoneNumber ? value.formated(by: "###-####-####") : value
                text.onNext(result)
            }
            .disposed(by: disposeBag)
        
        
        text
            .bind(to: input.userInput)
            .disposed(by: disposeBag)
        
        
        text
            .map { str in
                isFilled.onNext(str.isEmpty ? false : true)
                switch joinType {
                case .email:
                    self.newInfo.id = str
                    subjectInfo.onNext(self.newInfo)
                    return (str.range(of: RegexType.email.rawValue, options: .regularExpression) != nil)
                case .password:
                    self.newInfo.password = str
                    subjectInfo.onNext(self.newInfo)
                    return (str.range(of: RegexType.password.rawValue, options: .regularExpression) != nil)
                case .phoneNumber:
                    self.newInfo.phoneNumber = str
                    subjectInfo.onNext(self.newInfo)
                    return (str.range(of: RegexType.phoneNumber.rawValue, options: .regularExpression) != nil)
                default:
                    return false
                }
            }
            .bind(to: isValidText)
            .disposed(by: disposeBag)
        
        
        subjectInfo
            .onNext(newInfo)
        newInfo = input.userInfo
        
        
        if joinType == .email {
            
            input.validationButtonTap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .withLatestFrom(text)
                .flatMap { str in
                    let model = ValidationData(email: str)
                    return MoyaAPIManager.shared.fetchInSignProgress(.emailValidation(model: model), type: ValidationResponse.self)
                }
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let result):
                        print("===== success message: \(result.message)")
                        isValidToNext.onNext(true)
                    case .failure(let error):
                        print("======= error message: \(error.localizedDescription)")
                        isValidToNext.onNext(false)
                        input.userInput.onNext("")
                        self.completionHandler?(error.localizedDescription)
                    }
                }
                .disposed(by: disposeBag)
            
        } else if joinType == .phoneNumber {
            input.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .flatMap {
                    let model = SignUpData(email: self.newInfo.id, password: self.newInfo.password, phoneNum: self.newInfo.phoneNumber)
                    return MoyaAPIManager.shared.fetchInSignProgress(.signUp(model: model), type: JoinResponse.self)
                }
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let result):
                        print("===== success message: \(result.email)")
                    case .failure(let error):
                        print("======= error message: \(error)")
                        self.completionHandler?(error.localizedDescription)
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return Output(
            isValid: isValidText,
            isValidToNext: isValidToNext,
            tap: input.tap,
            userInfo: subjectInfo,
            text: text
        )
    }
}
