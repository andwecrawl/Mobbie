//
//  UIView_.swift
//  Mobbie
//
//  Created by yeoni on 12/20/23.
//

import UIKit

extension UIView {
  func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
