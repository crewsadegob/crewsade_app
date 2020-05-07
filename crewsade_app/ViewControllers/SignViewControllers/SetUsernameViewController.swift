//
//  SetUsernameViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 07/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class SetUsernameViewController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func completeButtonClicked(_ sender: Any) {
        if let username = usernameInput.text{
            UserService().setUsername(username: username)
        }
    }
}
