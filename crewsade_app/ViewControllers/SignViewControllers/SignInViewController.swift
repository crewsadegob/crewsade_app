//
//  SignInViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 01/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextView!
    @IBOutlet weak var passwordInput: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonSignInClicked(_ sender: Any) {
        
        if let email = emailInput.text, let password = passwordInput.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error{
                    print(error)
                }
                else{
                    print(result?.user)
                    let View: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainVC = View.instantiateViewController(identifier: "TabBar")
                    self.show(mainVC, sender: nil)
                }
            
               
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
