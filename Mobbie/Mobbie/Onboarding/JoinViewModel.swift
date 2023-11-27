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
        let tap: ControlEvent<Void>
        var userInfo: UserInfo
    }
    
    struct Output {
        
        let isValid: BehaviorSubject<Bool>
        let tap: ControlEvent<Void>
        let userInfo: UserInfo
    }
    
    func transform(input: Input) -> Output? {
        
        guard let joinType else { return nil }
        print(joinType)
        
        let isValid = BehaviorSubject(value: false)
        let isFilled = BehaviorSubject(value: true)
        let text = BehaviorSubject<String>(value: "")
        let subjectInfo = BehaviorSubject(value: input.userInfo)

        
        input.userInput
            .bind(with: self) { owner, value in
                let result = joinType == .phoneNumber ? value.formated(by: "###-####-####") : value
                text.onNext(result)
            }
            .disposed(by: disposeBag)
        
        text
            .bind(to: input.userInput)
            .disposed(by: disposeBag)
        
        subjectInfo
            .bind(with: self) { owner, value in
                value
            }
        
        newInfo = input.userInfo
        
        input.userInput
            .map { str in
                isFilled.onNext(str.isEmpty ? false : true)
                switch joinType {
                case .email:
                    self.newInfo.id = str
                    subjectInfo.onNext(self.newInfo)
                    print(self.newInfo)
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
            .bind(to: isValid)
            .disposed(by: disposeBag)
        
//        isValid
//            .debounce(.seconds(1), scheduler: MainScheduler.instance)
//            .subscribe(with: self) { owner, isValid in
//                if isValid {
//                    
//                } else {
//                    
//                }
//            }
//            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(isValid, isFilled)
            .map({ isValid, isFilled in
                return isValid && isFilled
            })
            .subscribe(with: self, onNext: { owner, value in
                if value {
                    
                }
            })
        
        switch joinType {
        case .email:
            
            input.userInput
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .flatMap { _ in
                    return MoyaAPIManager.shared.fetchInSignProgress(.emailValidation(email: self.newInfo.id), type: ValidationResponse.self) { self.completionHandler?($0.message) }
                }
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let result):
                        print("===== success message: \(result.message)")
                        isValid.onNext(true)
                    case .failure(let error):
                        "======= error message: \(error.localizedDescription)"
                        isValid.onNext(false)
                    }
                }
                .disposed(by: disposeBag)
            
        case .password:
            break
            
        case .phoneNumber:
            
            input.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .flatMap {
                    let model = SignUpData(email: self.newInfo.id, password: self.newInfo.password, phoneNum: self.newInfo.phoneNumber)
                    return MoyaAPIManager.shared.fetchInSignProgress(.signUp(model: model), type: JoinResponse.self) { print("error Handling: \($0)") }
                }
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let result):
                        print("===== success message: \(result.email)")
                    case .failure(let error):
                        "======= error message: \(error.localizedDescription)"
                    }
                }
                .disposed(by: disposeBag)
            
        case .end:
            
            input.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .flatMap {
                    return MoyaAPIManager.shared.fetchInSignProgress(.Login(email: self.newInfo.id, password: self.newInfo.password), type: LoginResponse.self) { print("error Handling: \($0)") }
                }
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let result):
                        print("===== login Success!!: \(result.email), \(result.password)")
                    case .failure(let error):
                        "======= error message: \(error.localizedDescription)"
                    }
                }
                .disposed(by: disposeBag)
            
        }
        
        print("newInfo: \(newInfo)")
        
        return Output(
            isValid: isValid,
            tap: input.tap,
            userInfo: newInfo
        )
    }
}
