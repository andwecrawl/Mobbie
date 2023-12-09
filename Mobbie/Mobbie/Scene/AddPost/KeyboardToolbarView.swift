//
//  KeyboardToolbarView.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/09.
//

import UIKit

class KeyboardToolbarView: UIView {
    
    let cameraButton = {
        let button = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        let photo = UIImage(systemName: "camera.fill", withConfiguration: imgConfig)
        button.setImage(photo, for: .normal)
        button.tintColor = UIColor.highlightMint
        button.snp.makeConstraints { make in
            make.size.equalTo(35)
        }
        return button
    }()
    
    let pictureButton = {
        let button = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        let photo = UIImage(systemName: "photo.fill", withConfiguration: imgConfig)
        button.setImage(photo, for: .normal)
        button.tintColor = UIColor.highlightMint
        button.snp.makeConstraints { make in
            make.size.equalTo(35)
        }
        return button
    }()
    
    let gifButton = {
        let button = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        let photo = Design.Pic.gif.toImg.withRenderingMode(.alwaysTemplate)
        button.setImage(photo, for: .normal)
        button.setPreferredSymbolConfiguration(imgConfig, forImageIn: .normal)
        button.tintColor = UIColor.highlightMint
        button.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        return button
    }()
    
    let locationButton = {
        let button = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16))
        let photo = UIImage(systemName: "photo", withConfiguration: imgConfig)
        button.setImage(photo, for: .normal)
        button.tintColor = UIColor.highlightMint
        button.snp.makeConstraints { make in
            make.size.equalTo(35)
        }
        return button
    }()
    
    let limitLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        label.textColor = UIColor.highlightMint
        label.text = "12/200"
        return label
    }()
    
    let buttonStackView = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureView() {
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 4
        buttonStackView.distribution = .equalSpacing
        
        buttonStackView.AddArrangedSubviews([cameraButton, pictureButton, gifButton])
        
        [buttonStackView, limitLabel]
            .forEach { self.addSubview($0) }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
        }
        
        limitLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    
}
