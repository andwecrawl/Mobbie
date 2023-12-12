//
//  PhotoCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView()
    var image: UIImage?
    var imagePath: String?
    
    var completionHandler: (() -> ())?
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        imageView.contentMode = .scaleAspectFill
        contentView.layer.cornerRadius = 8
    }
    
    func configureCell() {
        
        guard let imagePath else { return }
        
        // 추후 이미지 넣는 코드 작성
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(UserDefaultsHelper.shared.accessToken, forHTTPHeaderField: "Authorization")
            request.setValue(APIKeyURL.APIKey.rawValue, forHTTPHeaderField: "SesacKey")
            return request
        }
        
        let url = URL(string: APIKeyURL.baseURL.rawValue + imagePath)
        
        imageView.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: CGSize(width: imageView.frame.width, height: imageView.frame.height))),
            .requestModifier(modifier),
            .progressiveJPEG(.init(isBlur: true, isFastestScan: true, scanInterval: 0.1))
        ])
        
        
    }
    
    func configureUserImage() {
        guard let image else { return }
        
        imageView.image = image
    }
}
