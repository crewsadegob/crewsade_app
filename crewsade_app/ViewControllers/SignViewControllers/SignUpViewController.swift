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

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextView!
    @IBOutlet weak var passwordInput: UITextView!
    @IBOutlet weak var usernameInput: UITextView!
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func buttonSignUpClicked(_ sender: Any) {
        
        if let email = emailInput.text,let password = passwordInput.text, let username = usernameInput.text{
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let user = authResult?.user{
                    print(user)
                    self.db.collection("users").document(user.uid).setData([
                        "Username": username])
                }
                else{
                    print(error as Any)
                }
        }
          // ...
        }
    }
}
