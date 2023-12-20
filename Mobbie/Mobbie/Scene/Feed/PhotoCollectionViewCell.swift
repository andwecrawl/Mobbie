//
//  PhotoCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import UIKit
import Kingfisher

final class PhotoCollectionViewCell: BaseCollectionViewCell {
    
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
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .yellow
        imageView.clipsToBounds = true
    }
    
    func configureCell() {
        
        guard let imagePath else { return }
        
        KingfisherHelper.shared.fetchImage(imageURL: imagePath) { image, size in
            self.imageView.image = image
        } errorHandler: { error in
            self.imageView.backgroundColor = .gray
        }
    }
}
