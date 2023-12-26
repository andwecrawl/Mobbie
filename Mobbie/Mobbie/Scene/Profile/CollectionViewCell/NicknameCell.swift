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
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = UIImage(systemName: "gear", withConfiguration: imageConfig)
        config.image = image
        view.configuration = config
        view.tintColor = UIColor.gray
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let alertButton = {
        let view = UIButton()
        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .clear
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = UIImage(systemName: "bell.fill", withConfiguration: imageConfig)
        config.image = image
        view.configuration = config
        view.tintColor = UIColor.gray
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(nicknameView)
        contentView.addSubview(settingButton)
        contentView.addSubview(alertButton)
    }
    
    override func setConstraints() {
        nicknameView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(45)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        alertButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(40)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(alertButton)
            make.trailing.equalTo(alertButton).inset(46)
            make.size.equalTo(40)
        }
    }
    
}
