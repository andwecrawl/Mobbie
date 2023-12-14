//
//  CommentTableViewCell.swift
//  Mobbie
//
//  Created by yeoni on 12/14/23.
//

import UIKit

class CommentTableViewCell: BaseTableViewCell {
    
    private let userLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.midFont
        return label
    }()
    
    private let timeLabel = {
        let label = UILabel()
        label.textColor = .gray.withAlphaComponent(0.9)
        label.font = Design.Font.preRegular.smallFont
        return label
    }()
    
    private let contentLabel = {
        let label = UILabel()
        label.font = Design.Font.preRegular.getFonts(size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let commentButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        let image = UIImage(systemName: "bubble.left", withConfiguration: imageConfig)
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = Design.Font.preLight.smallFont
        titleContainer.foregroundColor = .gray.withAlphaComponent(0.9)
        config.attributedTitle = AttributedString("10", attributes: titleContainer)
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 4
        button.configuration = config
        button.tintColor = .gray.withAlphaComponent(0.8)
        return button
    }()
    
    let likedButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        let heartImage = UIImage(systemName: "heart", withConfiguration: imageConfig)
        let filledHeart = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
        button.setImage(heartImage, for: .normal)
        button.setImage(filledHeart, for: .selected)
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = Design.Font.preLight.smallFont
        titleContainer.foregroundColor = .gray.withAlphaComponent(0.9)
        config.attributedTitle = AttributedString("10", attributes: titleContainer)
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.tintColor = .gray.withAlphaComponent(0.8)
        return button
    }()
    
    let shareButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)
        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.tintColor = .gray.withAlphaComponent(0.8)
        return button
    }()
    
    let settingButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        button.tintColor = .gray.withAlphaComponent(0.8)
        button.setImage(image, for: .normal)
        return button
    }()
    
    let buttonStackView = UIStackView()
    
    var comment: Comment?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userLabel.text = ""
        timeLabel.text = "몇 시간 전"
        contentLabel.text = "내용이에용"
        likedButton.isSelected = false
        settingButton.isHidden = false
    }
    
    
    override func configureHierarchy() {
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .equalSpacing
        buttonStackView.AddArrangedSubviews([commentButton, likedButton, shareButton])
        
        [
            userLabel,
            timeLabel,
            contentLabel,
            buttonStackView,
            settingButton
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        userLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets).inset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userLabel)
            make.leading.equalTo(userLabel.snp.trailing).offset(6)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        buttonStackView.spacing = 10
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .leading
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.leading.equalTo(contentLabel)
            make.trailing.equalTo(contentLabel).inset(100)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().inset(4)
        }
        
        [commentButton, likedButton, shareButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height).multipliedBy(1.25)
            }
        }
    }
    
    override func configureView() {
        timeLabel.text = "20분 전"
        contentLabel.text = "내용이에용"
        contentLabel.setLineSpacing(lineSpacing: 4)
    }
    
    
    
}
