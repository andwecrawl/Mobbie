//
//  BaseViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/09.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configureHierarchy()
        setConstraints()
        configureView()
    }
    
    func setNavigationBar() {
    }
    
    func configureHierarchy() {
        view.backgroundColor = .background
    }
    
    func setConstraints() {
        
    }
    
    func configureView() {
        
        
    }
    
}
