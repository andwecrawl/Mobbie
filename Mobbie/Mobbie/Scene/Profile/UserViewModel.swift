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
    
    var cellType: BehaviorRelay<ProfileCellType> = BehaviorRelay(value: .feed)
    
    var disposeBag = DisposeBag()
    
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output? {
        
        cellType
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, cellType in
                
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
    
}
