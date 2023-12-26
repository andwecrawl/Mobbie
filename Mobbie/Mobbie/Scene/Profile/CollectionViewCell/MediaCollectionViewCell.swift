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
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    override func configureView() {
        imageView.backgroundColor = .gray
    }
    
    func configureCell(post: Post) {
        
        if let image = post.image.first {
            KingfisherHelper.shared.fetchImage(imageURL: image) { image, size in
                let ratio = size.height / size.width
                self.imageView.snp.makeConstraints { make in
                    make.height.equalTo(self.imageView.snp.width).multipliedBy(ratio)
                }
                self.imageView.image = image
            } errorHandler: { error in
                print("\(error)")
            }

        }
        
        
    }
    
    
}
