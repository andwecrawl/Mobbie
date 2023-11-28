//
//  Design.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/28.
//

import UIKit

enum Design {
    enum Color {
        case mint
        case orange
        case background
        case content
        
        var color: UIColor {
            switch self {
            case .mint:
                return UIColor.highlightMint
            case .orange:
                return UIColor.highlightOrange
            case .background:
                return UIColor.background
            case .content:
                return UIColor.content
            }
        }
    }
}

