//
//  APIManager.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation

import Moya
import RxSwift
import RxCocoa

final class MoyaAPIManager {
    
    static let shared = MoyaAPIManager()
    
    private init() { }
    
    private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request: URLRequest = try endpoint.urlRequest()
            request.timeoutInterval = 5
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    private lazy var provider = MoyaProvider<MoyaNetwork>(requestClosure: requestClosure, session: Session(interceptor: AuthInterceptor.shared))
    
    
    func fetchInSignProgress<T: Decodable>(_ api: MoyaNetwork, type: T.Type) -> Observable<Result<T, Error>> {
        print("hi")
        return Observable.create { observer in
            print("hello")
            self.provider.request(api) { response in
                
                switch response {
                case .success(let response):
                    print("============ response: \(response)")
                    print(String(data: response.data, encoding: .utf8))
                    let statusCode = response.statusCode
                    
                    if response.statusCode == 200 {
                        
                        guard let result = self.handleDecodingError(type: T.self, data: response.data) else { return }
                        print("============ success result: \(result)")
                        observer.onNext(.success(result))
                        
                    } else {
                        let error = LSLPError(rawValue: statusCode) ?? .undefinedError
                        
                        print("============ network error result: \(error)")
                        observer.onNext(.failure(error))
                    }
                    
                case .failure(let error):
                    
                    print("============ error result: \(error)")
                    observer.onError(error)
                    
                }
            }
            return Disposables.create()
        }
    }
    
    
    func handleDecodingError<T: Decodable>(type: T.Type, data: Data) -> T? {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch let DecodingError.dataCorrupted(context) {
             print(context)
         } catch let DecodingError.keyNotFound(key, context) {
             print("Key '\(key)' not found:", context.debugDescription)
             print("codingPath:", context.codingPath)
         } catch let DecodingError.valueNotFound(value, context) {
             print("Value '\(value)' not found:", context.debugDescription)
             print("codingPath:", context.codingPath)
         } catch let DecodingError.typeMismatch(type, context)  {
             print("Type '\(type)' mismatch:", context.debugDescription)
             print("codingPath:", context.codingPath)
         } catch {
             print("error: ", error)
         }
        return nil
    }
    
    
}
