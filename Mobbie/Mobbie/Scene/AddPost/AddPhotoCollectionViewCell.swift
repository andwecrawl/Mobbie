//
//  AddPhotoCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 12/12/23.
//

import UIKit

final class AddPhotoCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let deleteButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 9)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(button.snp.width)
        }
        return button
    }()
    
    var delegate: DeleteDelegate?
    
    var image: UIImage?
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        [
            imageView,
            deleteButton
        ]
            .forEach { contentView.addSubview($0) }
        
        imageView.layer.cornerRadius = 16
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).inset(6)
            make.trailing.equalTo(imageView).inset(6)
        }
    }
    
    override func configureView() {
        contentView.layer.cornerRadius = 12
    }
    
    @objc func deleteButtonClicked() {
        guard let image = imageView.image else { return }
        delegate?.deleteImages(image: image)
    }
    
    func configureUserImage() {
        guard let image else { return }
        
        imageView.image = image
    }
}

