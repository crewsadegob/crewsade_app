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
        GamesService().checkIsUserChallenged()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)


    }

    // fonction de remplacement Swift viewDidLoad() { super.viewDidLoad() if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller. } }
        
}

