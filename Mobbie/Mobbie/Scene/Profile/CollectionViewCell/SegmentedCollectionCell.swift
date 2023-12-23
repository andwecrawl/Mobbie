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
            make.bottom.equalTo(underlineView).inset(20)
        }
        
        underlineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.equalTo(3)
            make.bottom.equalToSuperview().inset(3)
        }
    }
    
    override func configureView() {
        underlineView.backgroundColor = .gray.withAlphaComponent(0.5)
    }
    
    func configureCell(item: ProfileSegmentData) {
        namelabel.text = item.title
        if item.isSelected {
            underlineView.isHidden = false
            underlineView.backgroundColor = .highlightOrange
        } else {
            underlineView.backgroundColor = .gray.withAlphaComponent(0.5)
            underlineView.isHidden = true
        }
    }
    
    
}
