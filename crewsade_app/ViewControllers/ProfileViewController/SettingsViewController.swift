//
//  SettingsViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutButtonClicked(_ sender: Any) {
        UserService().logOut(view:self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
