//
//  APIManager.swift
//  BMob
//
//  Created by yeoni on 2023/11/16.
//

import Foundation
import Moya

/*
 enum LSLPNetwork {
     case signUp(model: Model)
     case Login(email: String, password: String)
     case emailValidation(email: String)
 }
 */

class APIManager {
    
    static let shared = APIManager()
    private init() { }
    
    private let provider = MoyaProvider<LSLPNetwork>()
    
    func signUp(model: Model) {
        
        provider.request(.signUp(model: model)) { result in
            switch result {
            case .success(let value):
                print("success", value.statusCode)
                print(value.data)
                
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func login(email: String, password: String) {
        provider.request(.Login(email: email, password: password)) { result in
            switch result {
            case .success(let value):
                print("success", value.statusCode)
                print(value.data)
                
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func checkEmailValidation(email: String) {
        provider.request(.emailValidation(email: email)) { result in
            switch result {
            case .success(let value):
                print("success", value.statusCode)
                print(value.data)
                
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
