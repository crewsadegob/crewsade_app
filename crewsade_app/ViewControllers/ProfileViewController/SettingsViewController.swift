//
//  SettingsViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK: - ACTIONS
    
    @IBAction func signOutButtonClicked(_ sender: Any) {
        UserService().logOut(view:self)
    }
}
