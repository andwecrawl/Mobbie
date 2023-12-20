//
//  NicknameView.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit

class NicknameView: UIView {
    let nicknameLabel = {
        let label = UILabel()
        label.text = "새콤달콤한 주전자"
        label.font = Design.Font.preSemiBold.exlargeFont
        return label
    }()
    
    let refreshButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureView() {
        [
            nicknameLabel,
            refreshButton
        ]
            .forEach { self.addSubview($0) }
        
        nicknameLabel.sizeToFit()
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8)
            make.size.equalTo(30)
        }
        
        nicknameLabel.text = UserDefaultsHelper.shared.nickname
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    @objc func refreshButtonTapped() {
        UserDefaultsHelper.shared.nickname = Nickname.shared.makeNewNickname()
        nicknameLabel.text = UserDefaultsHelper.shared.nickname
    }
    
}
