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
    
    var showPasswordIcon:Bool = true
    
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    let signUpManager = FirebaseAuthManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailInput.setLeftPaddingPoints(10)
        passwordInput.setLeftPaddingPoints(10)
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func buttonSignUpClicked(_ sender: Any) {
        
        if let email = emailInput.text,let password = passwordInput.text{
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                if (success) {
                    self.switchToSetUsernameStoryboard()
                } else {
                    print("Error")
                }
            }
        }
    }
    @IBAction func showPassword(_ sender: Any) {
        if(showPasswordIcon == true) {
                         passwordInput.isSecureTextEntry = false
                     } else {
                         passwordInput.isSecureTextEntry = true
                     }

                     showPasswordIcon = !showPasswordIcon
    }
    
    private func switchToSetUsernameStoryboard(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Username", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "SetUsername")
        self.show(mainViewController, sender: nil)
    }
}


