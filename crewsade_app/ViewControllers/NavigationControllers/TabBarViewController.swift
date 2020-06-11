//
//  TabBarViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

// MARK: - VARIABLES
    
    @IBOutlet weak var TabBar: UITabBar!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = false
    }

}
