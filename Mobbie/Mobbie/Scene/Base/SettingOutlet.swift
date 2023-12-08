//
//  SettingOutlet.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/01.
//

import UIKit

extension UIView {
    
    func makeShadow(radius: CGFloat = 10, opacity: Float = 0.3) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.clipsToBounds = false
    }
}
