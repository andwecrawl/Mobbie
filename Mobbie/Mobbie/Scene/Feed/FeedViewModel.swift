//
//  FeedViewModel.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/05.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedViewModel: ViewModel {
    
    var posts: [Post] = []
    var cursor = PublishSubject<String>()
    var feedType: FeedType?
    var disposeBag = DisposeBag()
    
    
    struct Input {
        let addButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let addButtonTapped: ControlEvent<Void>
        let getData: PublishSubject<Bool>
        let nextCursor: BehaviorSubject<String>
        let errorMessage: BehaviorSubject<String>
    }
    
    func transform(input: Input) -> Output? {
        let feedType = feedType ?? .mainFeed
        
        let getData = PublishSubject<Bool>()
        let nextCursor = BehaviorSubject(value: "")
        let isError = BehaviorSubject(value: "")
        let data = PublishSubject<Result<PostResponse, Error>>()
        
        data
            .bind(with: self) { owner, response in
                switch response {
                case .success(let result):
                    owner.posts.append(contentsOf: result.data)
                    getData.onNext(true)
                    nextCursor.onNext(result.nextCursor)
                case .failure(let error):
                    isError.onNext(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        
        cursor
            .flatMap { cursor in
                switch feedType {
                case .mainFeed:
                    return MoyaAPIManager.shared.fetchInSignProgress(.fetchPost(nextCursor: cursor), type: PostResponse.self)
                case .profileFeed:
                    return MoyaAPIManager.shared.fetchInSignProgress(.fetchMyPosts(userID: UserDefaultsHelper.shared.userID), type: PostResponse.self)
                case .likedFeed:
                    return MoyaAPIManager.shared.fetchInSignProgress(.fetchPostUserLiked, type: PostResponse.self)
                }
            }
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
            .disposed(by: disposeBag)
        
        return Output(
            addButtonTapped: input.addButtonTapped,
            getData: getData,
            nextCursor: nextCursor,
            errorMessage: isError
        )
    }
}
