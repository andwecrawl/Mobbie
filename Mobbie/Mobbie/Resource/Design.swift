//
//  Design.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/28.
//

import UIKit

enum Design {
    enum Pic: String {
        case gif
        
        var toImg: UIImage {
            switch self {
            case .gif:
                return UIImage(named: self.rawValue)!
            }
        }
    }
    
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
    
    enum Font: String {
        case preLight = "Pretendard-Light"
        case preRegular = "Pretendard-Regular"
        case preMedium = "Pretendard-Medium"
        case preSemiBold = "Pretendard-SemiBold"
        case preBold = "Pretendard-Bold"
        case changwon = "ChangwonDangamAsac"
        case chab = "LOTTERIACHAB"
        
        /// 아이폰 작은 글씨(size: 12)
        var smallFont: UIFont {
            return UIFont(name: self.rawValue, size: FontSize.small.rawValue)!
        }
        
        var midFont: UIFont {
            return UIFont(name: self.rawValue, size: FontSize.medium.rawValue)!
        }
        
        var largeFont: UIFont {
            return UIFont(name: self.rawValue, size: FontSize.large.rawValue)!
        }
        
        var exlargeFont: UIFont {
            return UIFont(name: self.rawValue, size: FontSize.extraLarge.rawValue)!
        }
        
        func getFonts(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
        
        enum FontSize: CGFloat {
            case small = 14
            case medium = 15
            case large = 16
            case extraLarge = 28
        }
    }
    
}

