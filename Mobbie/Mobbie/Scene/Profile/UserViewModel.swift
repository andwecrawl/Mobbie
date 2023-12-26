//
//  UserViewModel.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit
import RxSwift
import RxCocoa

class UserViewModel: ViewModel {
    
    var posts: [Post] = []
    var cursor = PublishSubject<String>()
    
    var cellType: BehaviorRelay<ProfileCellType> = BehaviorRelay(value: .media)
    
    var disposeBag = DisposeBag()
    
    
    struct Input {
    }
    
    struct Output {
        let cellType: BehaviorRelay<ProfileCellType>
        let nextCursor: BehaviorSubject<String>
        let errorMessage: BehaviorSubject<String>
    }
    
    func transform(input: Input) -> Output? {
        
        let nextCursor = BehaviorSubject(value: "")
        let errorMessage = BehaviorSubject(value: "")
        let data = PublishSubject<Result<PostResponse, Error>>()
        
        data
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    nextCursor.onNext(result.nextCursor)
                    
                    if owner.cellType.value == .media {
                        let picPosts = result.data.filter({ $0.image.count > 0 })
                        owner.posts.append(contentsOf: picPosts)
                        
                    } else {
                        owner.posts.append(contentsOf: result.data)
                    }
                case .failure(let error):
                    errorMessage.onNext(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        
        cursor
            .flatMapLatest({ [weak self] value in
                
                switch self?.cellType.value {
                case .media:
                    return MoyaAPIManager.shared.fetchInSignProgress(.fetchMyPosts(userID: UserDefaultsHelper.shared.userID), type: PostResponse.self)
                case .liked:
                    return MoyaAPIManager.shared.fetchInSignProgress(.fetchPostUserLiked, type: PostResponse.self)
                default:
                    return MoyaAPIManager.shared.fetchInSignProgress(.fetchMyPosts(userID: UserDefaultsHelper.shared.userID), type: PostResponse.self)
                }
            })
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    print(result)
                    data.onNext(.success(result))
                case .failure(let error):
                    print(error.localizedDescription)
                    data.onNext(.failure(error))
                }
            }
            .disposed(by: disposeBag)
        
        
        cellType
            .subscribe(with: self) { owner, _ in
                owner.cursor.onNext("")
                owner.posts = []
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            cellType: cellType,
            nextCursor: nextCursor,
            errorMessage: errorMessage
        )
    }
    
    
}
