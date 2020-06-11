//
//  ForgotPasswordViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 09/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
// MARK: - VARIABLES
    
    @IBOutlet weak var emailInput: UITextField!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        emailInput.setLeftPaddingPoints(10)
    }
    
// MARK: - ACTIONS
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        if let email = emailInput.text{
            FirebaseAuthManager().resetPassword(email: email){[weak self] (success) in
                guard let `self` = self else { return }
                if (success) {
                    let alert = UIAlertController(title: "Mot de passe oublié", message: "Un email vous a été envoyé", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("There was an error.")
                }
            }
        }
    }
}
