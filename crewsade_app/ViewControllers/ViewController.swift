//
//  ViewController.swift
//  crewsade_app
//
//  Created by Lou Batier on 20/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
       let loginButton = FBLoginButton()
        let buttonText = NSAttributedString(string: "Connexion avec Facebook")
        loginButton.setAttributedTitle(buttonText, for: .normal)
       loginButton.center = view.center
       view.addSubview(loginButton)
      
    }
    

    // fonction de remplacement Swift viewDidLoad() { super.viewDidLoad() if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller. } }
        
}

