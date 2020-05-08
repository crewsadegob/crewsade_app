//
//  SignInViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 01/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
class SignInViewController: UIViewController {
    
    var showPasswordIcon:Bool = true
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailInput.setLeftPaddingPoints(10)
        passwordInput.setLeftPaddingPoints(10)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false
    }
    
    @IBAction func buttonSignInClicked(_ sender: Any) {
        if let email = emailInput.text, let password = passwordInput.text {
            FirebaseAuthManager().signIn(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                if (success) {
                    self.switchToMainStoryboard()
                } else {
                    print("There was an error.")
                }
            }
        }
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
         if(showPasswordIcon == true) {
                 passwordInput.isSecureTextEntry = false
                 sender.setBackgroundImage(UIImage(named: "eyeOpen.png"), for: .normal)
             } else {
                 passwordInput.isSecureTextEntry = true
                 sender.setBackgroundImage(UIImage(named: "eyeClose.png"), for: .normal)
             }
             
             showPasswordIcon = !showPasswordIcon
    }
    private func switchToMainStoryboard(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
        self.show(mainViewController, sender: nil)
    }
    
    
}
