//
//  KingFisherManager.swift
//  Mobbie
//
//  Created by yeoni on 12/20/23.
//

import UIKit
import Kingfisher

class KingfisherHelper {
    
    static let shared = KingfisherHelper()
    
    private init() { }
    
    
    func fetchImage(imageURL: String, completionHandler: @escaping (_ image: UIImage, _ size: CGSize) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(UserDefaultsHelper.shared.accessToken, forHTTPHeaderField: "Authorization")
            request.setValue(APIKeyURL.APIKey.rawValue, forHTTPHeaderField: "SesacKey")
            return request
        }
        
        
        if let url = URL(string: APIKeyURL.baseURL.rawValue + imageURL) {
            KingfisherManager.shared.retrieveImage(with: url, options: [
                .requestModifier(modifier)
            ]) { response in
                switch response {
                    
                case .success(let result):
                    let image = result.image
                    let size = result.image.size
                    DispatchQueue.main.async {
                        completionHandler(image, size)
                    }
                    
                case .failure(let error):
                    print(error)
                    errorHandler(error)
                }
            }
        }
    }
}
