//
//  UIViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 29/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func hideNavigation() {
        self.navigationController?.isNavigationBarHidden = true
    }
    func displayNavigation() {
        self.navigationController?.isNavigationBarHidden = false
    }
    func hideDefaultTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
//    func initCustomTabar() {
//        let customTabBar: CustomTabBar = {
//            let ctb = CustomTabBar()
//            return ctb
//        }()
//        
//        view.addSubview(customTabBar)
//        let bottomConstraint = NSLayoutConstraint(
//            item: customTabBar,
//            attribute: NSLayoutConstraint.Attribute.bottom,
//            relatedBy: NSLayoutConstraint.Relation.equal,
//            toItem: self.view,
//            attribute: NSLayoutConstraint.Attribute.bottom,
//            multiplier: 1,
//            constant: 0
//        )
//        
//        let heightConstraint = NSLayoutConstraint(
//            item: customTabBar,
//            attribute: NSLayoutConstraint.Attribute.height,
//            relatedBy: NSLayoutConstraint.Relation.equal,
//            toItem: nil,
//            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
//            multiplier: 1,
//            constant: 100
//        )
//        
//        view.addConstraints([bottomConstraint, heightConstraint])
//    }
}
