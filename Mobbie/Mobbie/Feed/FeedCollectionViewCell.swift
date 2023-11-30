//
//  FeedCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/29.
//

import UIKit

class FeedCollectionViewCell: BaseCollectionViewCell {
    
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
    
    let textLabel = {
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
        
    }
    
    override func setConstraints() {
        
    }
    
    override func configureView() {
        
    }
}
