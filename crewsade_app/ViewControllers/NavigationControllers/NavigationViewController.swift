//
//  NavigationViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 11/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = false
        
        let backImage = UIImage(named: "backItemLight")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
    }
}
