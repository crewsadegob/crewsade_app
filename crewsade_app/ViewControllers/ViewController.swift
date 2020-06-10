//
//  ViewController.swift
//  crewsade_app
//
//  Created by Lou Batier on 20/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreLocation

class ViewController: UIViewController, TapHandler {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GamesService().checkIsUserChallenged(view:self)
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let allViews = Bundle.main.loadNibNamed("CrewsadeTabBar", owner: CrewsadeTabBar(), options: nil)

        let tabBar = allViews?.first as! CrewsadeTabBar
        tabBar.frame = CGRect(x: 0, y: 190, width: view.frame.width, height: 170)
        tabBar.tapHandler = self
        self.view.addSubview(tabBar)
    }
    
    func tapped(index: Int) {
        switch index {
            case 0: self.tabBarController?.selectedIndex = 0
            case 1: self.tabBarController?.selectedIndex = 1
            case 2: self.tabBarController?.selectedIndex = 2
            case 3: self.tabBarController?.selectedIndex = 3
            default: break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // fonction de remplacement Swift viewDidLoad() { super.viewDidLoad() if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller. } }
        
}
