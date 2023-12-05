//
//  FeedViewModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/05.
//

import Foundation
import RxSwift
import RxCocoa

class FeedViewModel: ViewModel {
    
    var cursor = PublishSubject<String>()
    var disposeBag = DisposeBag()
    
    
    struct Input {
        let addButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let addButtonTapped: ControlEvent<Void>
        let data: PublishSubject<Result<PostResponse, Error>>
    }
    
    func transform(input: Input) -> Output? {
        
        let data = PublishSubject<Result<PostResponse, Error>>()
        
        cursor
            .subscribe(with: self) { owner, cursor in
                
            MoyaAPIManager.shared.fetchInSignProgress(.fetchPost(nextCursor: cursor), type: PostResponse.self)
                .bind(with: self) { owner, response in
                    switch response {
                    case .success(let result):
                        data.onNext(.success(result))
                        print("success Result: \(result)")
                    case .failure(let error):
                        data.onNext(.failure(error))
                        print("error Result: \(error)")
                    }
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(
            addButtonTapped: input.addButtonTapped,
            data: data
            
        )
    }
}
