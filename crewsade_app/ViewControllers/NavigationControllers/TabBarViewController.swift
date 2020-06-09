//
//  TabBarViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet weak var TabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = false
    }

}
