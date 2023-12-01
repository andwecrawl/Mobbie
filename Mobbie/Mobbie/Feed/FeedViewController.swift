//
//  FeedViewController.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/10.
//

import UIKit

final class FeedViewController: BaseViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
    }
    
    override func setConstraints() {
        
    }
    
    override func configureView() {
        
    }
    
    /// Show the loading empty state
    private func showLoading() {
        
        var config = UIContentUnavailableConfiguration.loading()
        config.text = "Fetching content. Please wait..."
        config.textProperties.font = Design.Font.preSemiBold.largeFont
        
        self.contentUnavailableConfiguration = config
    }
    
    
}
