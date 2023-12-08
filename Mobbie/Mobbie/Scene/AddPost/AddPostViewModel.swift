//
//  AddPostViewModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/07.
//

import UIKit
import RxSwift
import RxCocoa

class AddPostViewModel: ViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let addButtonTapped: ControlEvent<Void>
        let text: ControlProperty<String>
    }
    
    var transition: TransitionProtocol?
    var alert: ((String, String) -> ())?
    
    struct Output {
        let addButtonTapped: ControlEvent<Void>
        let text: ControlProperty<String>
        let isSaved: PublishRelay<Bool>
        let errorMessage: BehaviorRelay<String>
    }
    
    func transform(input: Input) -> Output? {
        
        let isSaved = PublishRelay<Bool>()
        let errorMessage = BehaviorRelay(value: "")

        input.addButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.text)
            .filter { !$0.replacingOccurrences(of: " ", with: "").isEmpty }
            .flatMap { str in
                MoyaAPIManager.shared.fetchInSignProgress(.writePost(model: PostModel(content: str, product_id: "")), type: Posts.self)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(_):
                    isSaved.accept(true)
                case .failure(let error):
                    isSaved.accept(false)
                    errorMessage.accept(error.localizedDescription)
                }
            } onError: { owner, error in
                if error.localizedDescription == "expiredRefreshToken" {
                    owner.alert?("세션이 만료되었습니다.", "다시 로그인 해주세요!")
                    owner.transition?.transitionTo(LoginViewController())
                }
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(
            addButtonTapped: input.addButtonTapped,
            text: input.text,
            isSaved: isSaved,
            errorMessage: errorMessage
        )
    }
}
