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
    
    @IBOutlet weak var errorDisplay: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    let signInManager = FirebaseAuthManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailInput.setLeftPaddingPoints(10)
        passwordInput.setLeftPaddingPoints(10)
        GIDSignIn.sharedInstance()?.presentingViewController = self

    }
    

    @IBAction func facebookButton(_ sender: Any) {
        signInManager.facebookLogin(sender, viewController: self){[weak self] (success) in
            guard let `self` = self else { return }
            if (success) {
                self.switchToMainStoryboard()
            } else {
                print("There was an error.")
            }
        }
    }
    @IBAction func googleButtonclicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func buttonSignInClicked(_ sender: Any) {
        if let email = emailInput.text, let password = passwordInput.text {
            signInManager.signIn(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                    if (success) {
                        self.switchToMainStoryboard()
                    } else {
                        print("There was an error.")
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
    private func switchToMainStoryboard(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
        self.show(mainViewController, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false
        
    }
}
