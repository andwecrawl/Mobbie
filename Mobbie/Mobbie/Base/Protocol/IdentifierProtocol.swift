//
//  IdentifierProtocol.swift
//  Mobbie
//
//  Created by yeoni on 2023/12/03.
//

import UIKit

protocol IdentifierProtocol: AnyObject {
    static var identifier: String { get }
}

extension UIViewController: IdentifierProtocol {
    static var identifier: String {
        return self.description()
    }
}

extension UICollectionViewCell: IdentifierProtocol {
    static var identifier: String {
        return self.description()
    }
}

extension UITableViewCell: IdentifierProtocol {
    static var identifier: String {
        return self.description()
    }
}
