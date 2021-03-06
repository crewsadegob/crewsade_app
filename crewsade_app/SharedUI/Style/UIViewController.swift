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
    
    func showStoryboard(storyboard: String, identifier: String){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: storyboard, bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: identifier)
        self.show(mainViewController, sender: nil)
    }

}
