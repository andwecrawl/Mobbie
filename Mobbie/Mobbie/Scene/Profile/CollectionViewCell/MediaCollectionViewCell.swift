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
    
    override func configureView() {
        imageView.backgroundColor = .gray
    }
    
    func configureCell(post: Post) {
        
        if let image = post.image.first {
            KingfisherHelper.shared.fetchImage(imageURL: image) { [weak self] image, size in
                if let self {
                    print(size)
                    let ratio = size.height / size.width
                    print(ratio)
                    self.imageView.snp.remakeConstraints { make in
                        make.edges.equalToSuperview()
                        make.height.equalTo(self.imageView.snp.width).multipliedBy(ratio).priority(999)
                    }
                    self.imageView.image = image
                    print(self.imageView.frame)
                    
                    invalidateIntrinsicContentSize()
                }
            } errorHandler: { error in
                print("\(error)")
            }

        }
        
        
    }
    
    
}
