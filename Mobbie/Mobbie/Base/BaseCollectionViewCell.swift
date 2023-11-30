//
//  BaseCollectionViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/29.
//

import Foundation

import UIKit
import SnapKit

class BaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "BaseCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        setConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureHierarchy() {
        
    }
    
    func setConstraints() {
        
    }
    
    func configureView() {
        
        
    }
    
}
