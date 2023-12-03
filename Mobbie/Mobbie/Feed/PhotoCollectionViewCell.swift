//
//  PhotoCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import UIKit

class PhotoCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView()
    
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
        
        // 추후 이미지 넣는 코드 작성
        
    }
}
