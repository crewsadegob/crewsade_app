//
//  SignUpViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit
import FBSDKCoreKit
class SignUpViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextView!
    @IBOutlet weak var passwordInput: UITextView!
    @IBOutlet weak var usernameInput: UITextView!
    
    let signUpManager = FirebaseAuthManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
        // Do any additional setup after loading the view.

    }
 
    @IBAction func buttonSignUpClicked(_ sender: Any) {
        
        if let email = emailInput.text,let password = passwordInput.text, let username = usernameInput.text{
            signUpManager.createUser(email: email, password: password,username: username) {[weak self] (success) in
                guard let `self` = self else { return }
                if (success) {
                    self.switchToMainStoryboard()
                } else {
                    print("Error")
                }
            }
        }
    }
    
    private func switchToMainStoryboard(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
        self.show(mainViewController, sender: nil)
    }
}


