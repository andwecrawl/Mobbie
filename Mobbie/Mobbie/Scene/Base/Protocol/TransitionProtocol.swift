//
//  TransitionProtocol.swift
//  Mobbie
//
//  Created by yeoni on 2023/11/30.
//

import UIKit

protocol TransitionProtocol {
    func transitionTo(_ viewController: UIViewController)
}

extension TransitionProtocol {
    func transitionTo(_ viewController: UIViewController) {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let SceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let nav = UINavigationController(rootViewController: viewController)
        
        UserDefaultsHelper.shared.haveBeenBefore = true
        
        UIView.transition(with: SceneDelegate?.window ?? UIWindow(), duration: 0.3, options: .transitionCrossDissolve, animations: {
            SceneDelegate?.window?.rootViewController = nav
        }) { (completed) in
            if completed {
                SceneDelegate?.window?.makeKeyAndVisible()
            }
        }
        
        
    }
}
