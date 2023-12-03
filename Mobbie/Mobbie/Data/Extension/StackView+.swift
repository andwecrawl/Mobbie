//
//  StackView+.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import UIKit

extension UIStackView {
    
    func AddArrangedSubviews(_ contentsOf: [UIView]) {
        contentsOf.forEach { self.addArrangedSubview($0) }
    }
}
