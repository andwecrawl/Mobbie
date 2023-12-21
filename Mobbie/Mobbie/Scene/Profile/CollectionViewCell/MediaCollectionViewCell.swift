//
//  MediaCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit

class MediaCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .gray
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
//    override func configureView(post: Post) {
////        post.image.isEmpty
//    }
    
    
}
