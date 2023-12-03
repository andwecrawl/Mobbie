//
//  BaseTableViewCell.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import Foundation

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
