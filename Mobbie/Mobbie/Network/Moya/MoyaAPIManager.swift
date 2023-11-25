//
//  APIManager.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation

import Moya
import Alamofire
import RxSwift
import RxCocoa



class MoyaAPIManager {
    
    static let shared = MoyaAPIManager()
    
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
    
    private lazy var provider = MoyaProvider<MoyaNetwork>(requestClosure: requestClosure)
    
    
    func fetchInSignProgress<T: Decodable>(_ api: MoyaNetwork, type: T.Type, errorHandler: @escaping (ErrorResponse) -> Void) -> Observable<Result<T, Error>> {
        print("hi")
        return Observable.create { observer in
            print("hello")
            self.provider.request(api) { response in
                
                switch response {
                case .success(let response):
                    print("============ response: \(response)")
                    let statusCode = response.statusCode
                    
                    if response.statusCode == 200 {
                        
                        let result = try! JSONDecoder().decode(T.self, from: response.data)
                        print("============ success result: \(result)")
                        observer.onNext(.success(result))
                        
                    } else {
                        let value = try! JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        let error = LSLPError(rawValue: statusCode) ?? .undefinedError
                        errorHandler(value)
                        
                        print("============ network error result: \(value)")
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
