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
    
    
// MARK: - VARIABLES
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Heebo-Regular.ttf", size: 12) ?? UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.CrewSade.darkGrey.withAlphaComponent(0.5),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    var showPasswordIcon:Bool = true
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInput.setLeftPaddingPoints(10)
        passwordInput.setLeftPaddingPoints(10)
        
        let attributeString = NSMutableAttributedString(string: "Mot de passe oublié ?",attributes: yourAttributes)
        forgotPasswordButton.setAttributedTitle(attributeString, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
// MARK: - ACTIONS
    
    @IBAction func buttonSignInClicked(_ sender: Any) {
        indicator.startAnimating()
        if let email = emailInput.text, let password = passwordInput.text {
            FirebaseAuthManager().signIn(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                if (success) {
                    self.indicator.stopAnimating()
                    self.switchToMainStoryboard()
                } else {
                    self.indicator.stopAnimating()
                    print("There was an error.")
                }
            }
        }
    }
    
    @IBAction func forgotPasswordButtonClicked(_ sender: Any) {
        
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
    
// MARK: - METHODS
    
    private func switchToMainStoryboard(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
        self.show(mainViewController, sender: nil)
    }
}
