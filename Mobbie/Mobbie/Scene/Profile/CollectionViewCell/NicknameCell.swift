//
//  NicknameCell.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit

class NicknameCell: BaseCollectionViewCell {
    
    let nicknameView = NicknameView()
    
    let settingButton = {
        let view = UIButton()
        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .clear
        var container = AttributeContainer()
        container.foregroundColor = UIColor.white
        container.font = Design.Font.preMedium.smallFont
        config.attributedTitle = AttributedString("프로필 수정", attributes: container)
        view.configuration = config
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(nicknameView)
        contentView.addSubview(settingButton)
    }
    
    override func setConstraints() {
        nicknameView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(45)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
    }
    
}
