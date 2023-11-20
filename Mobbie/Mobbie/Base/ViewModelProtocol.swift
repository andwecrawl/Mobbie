//
//  ViewModelProtocol.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/20.
//

import Foundation
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output?
}
