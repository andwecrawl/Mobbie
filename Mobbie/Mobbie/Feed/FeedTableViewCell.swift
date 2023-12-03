//
//  FeedCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/29.
//

import UIKit

final class FeedTableViewCell: BaseTableViewCell {
    
    let userLabel = {
        let label = UILabel()
        label.font = Design.Font.preSemiBold.largeFont
        return label
    }()
    
    let timeLabel = {
        let label = UILabel()
        label.font = Design.Font.preRegular.largeFont
        return label
    }()
    
    let contentLabel = {
        let label = UILabel()
        label.font = Design.Font.preMedium.largeFont
        label.numberOfLines = 0
        return label
    }()
    
    let commentButton = {
        let button = UIButton()
        button.titleLabel?.font = Design.Font.preLight.largeFont
        return button
    }()
    
    let likedButton = {
        let button = UIButton()
        button.titleLabel?.font = Design.Font.preLight.largeFont
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        return button
    }()
    
    let detailButton = {
        let button = UIButton()
        button.titleLabel?.font = Design.Font.preLight.largeFont
        return button
    }()
    
    
    override func configureHierarchy() {
        
        [
            userLabel,
            timeLabel,
            contentLabel,
            commentButton,
            likedButton,
            detailButton
        ]
            .forEach { contentView.addSubview($0) }
        
        
    }
    
    override func setConstraints() {
        
        userLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel)
            make.leading.equalTo(userLabel.snp.trailing).offset(4)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        
        
    }
    
    override func configureView() {
        
    }
}
