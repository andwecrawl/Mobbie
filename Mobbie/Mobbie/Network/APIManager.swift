//
//  APIManager.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation

import Moya
import RxMoya
import RxSwift
import RxCocoa


class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request: URLRequest = try endpoint.urlRequest()
            request.timeoutInterval = 10
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    private lazy var provider = MoyaProvider<LSLPNetwork>(requestClosure: requestClosure)
    
    func fetchInSignProgress(_ networkCase: LSLPNetwork) -> Single<Response> {
        return provider.rx.request(networkCase)
    }
}
