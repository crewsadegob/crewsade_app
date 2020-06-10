//
//  GamesViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 12/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit



class GamesViewController: UIViewController {

    @IBOutlet weak var customTabBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customTabBar.backgroundColor = UIColor.CrewSade.darkGrey
        customTabBar.roundTopCorners()
        
    }
    
    @IBAction func tabButtonClicked(_ sender: UIButton) {
        
        switch sender.tag {
            case 0: self.tabBarController?.selectedIndex = 0
            case 1: self.tabBarController?.selectedIndex = 1
            case 2: self.tabBarController?.selectedIndex = 2
            case 3: self.tabBarController?.selectedIndex = 3
            default: break
        }
        
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
