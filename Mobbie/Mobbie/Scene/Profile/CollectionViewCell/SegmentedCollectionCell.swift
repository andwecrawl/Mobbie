//
//  SegmentedCollectionCell.swift
//  Mobbie
//
//  Created by yeoni on 12/21/23.
//

import UIKit

class SegmentedCollectionCell: BaseCollectionViewCell {
    
    let namelabel = {
        let label = UILabel()
        label.font = Design.Font.preRegular.midFont
        label.text = "종류예용"
        return label
    }()
    
    let underlineView = UIView()
    
    override func configureHierarchy() {
        [
            namelabel,
            underlineView
        ]
            .forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        namelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(underlineView).inset(4)
        }
        
        underlineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(2)
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
    
    
}
