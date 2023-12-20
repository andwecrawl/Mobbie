//
//  NicknameCell.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit

class NicknameCell: BaseCollectionViewCell {
    
    let nicknameView = NicknameView()
    
    override func configureHierarchy() {
        contentView.addSubview(nicknameView)
    }
    
    override func setConstraints() {
        nicknameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
