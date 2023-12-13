//
//  AddPhotoCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 12/12/23.
//

import UIKit

protocol AddDelegate {
    func openPhotoAlbum()
    func takePhoto()
}

protocol DeleteDelegate {
    func deleteImages(image: UIImage)
}


class AddButtonCollectionViewCell: BaseCollectionViewCell {
    
    let button = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.highlightOrange.cgColor
        button.backgroundColor = .clear
        button.tintColor = UIColor.highlightOrange
        return button
    }()
    
    var delegate: AddDelegate?
    
    override func configureHierarchy() {
        contentView.addSubview(button)
    }
    
    override func setConstraints() {
        button.snp.makeConstraints { make in
            make.size.equalTo(90)
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        let menuElement: [UIMenuElement] = [
            UIAction(title: "사진 보관함", image: UIImage(systemName: "photo"), handler: { _ in
                self.delegate?.openPhotoAlbum()
            }),
            UIAction(title: "사진 찍기", image: UIImage(systemName: "camera"), handler: { _ in
                self.delegate?.takePhoto()
            })
        ]
        button.menu = UIMenu(children: menuElement)
        button.showsMenuAsPrimaryAction = true
        
        configureAddButton(imagesCount: 0)
    }
    
    func configureAddButton(imagesCount: Int) {
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16)
        config.image = UIImage(systemName: "camera", withConfiguration: imageConfig)
        config.imagePlacement = .top
        config.imagePadding = 4
        var titleContainer = AttributeContainer()
        titleContainer.font = Design.Font.preRegular.midFont
        titleContainer.foregroundColor = UIColor.systemGray
        config.attributedTitle = AttributedString("\(imagesCount)/4", attributes: titleContainer)
        button.configuration = config
    }
    
}
