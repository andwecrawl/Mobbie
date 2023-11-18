//
//  JoinViewModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/10.
//

import Foundation
import RxSwift
import RxCocoa

class JoinViewModel {
    
    var VCType: VCType?
    let disposeBag = DisposeBag()
    
    struct Input {
        let userInput: ControlProperty<String>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        
        let isValid: BehaviorSubject<Bool>
        let tap: ControlEvent<Void>
        
    }
    
    func translate(input: Input) -> Output? {
        
        guard let VCType else { return nil }
        
        let isValid = BehaviorSubject(value: false)
        let text = BehaviorSubject<String>(value: "")
        
        input.userInput
            .bind(with: self) { owner, value in
                let result = VCType == .phoneNumber ? value.formated(by: "###-####-####") : value
                text.onNext(result)
            }
            .disposed(by: disposeBag)
        
        input.userInput
            .map { str in
                switch VCType {
                case .email:
                    return (str.range(of: RegexType.email.rawValue, options: .regularExpression) != nil)
                case .password:
                    return (str.range(of: RegexType.password.rawValue, options: .regularExpression) != nil)
                case .phoneNumber:
                    return (str.range(of: RegexType.phoneNumber.rawValue, options: .regularExpression) != nil)
                default:
                    return false
                }
            }
            .bind(to: isValid)
            .disposed(by: disposeBag)
        
        text
            .bind(to: input.userInput)
            .disposed(by: disposeBag)
        
        return Output(
            isValid: isValid,
            tap: input.tap
        )
    }
}
