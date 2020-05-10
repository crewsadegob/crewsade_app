//
//  SignsViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 07/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import  FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
class SignsViewController: UIViewController, GIDSignInDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setCrewsadeNavigation()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
              GIDSignIn.sharedInstance()?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    private func setCrewsadeNavigation(){
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().barTintColor = UIColor.CrewSade.secondaryColorLight
    }
    
    @IBAction func facebookButtonClicked(_ sender: Any) {
        FacebookAuthManager().facebookLogin(sender, viewController: self){[weak self] (success) in
               guard let `self` = self else { return }
               if (success) {
                   self.switchToMainStoryboard()
               } else {
                   print("There was an error.")
               }
           }
    }
    
    @IBAction func googleButtonClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
        // When user is signed in
        Auth.auth().signIn(with: credential)  { (authResult, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
            self.switchToMainStoryboard()
            
        }
    }
    
    private func switchToMainStoryboard(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
        self.show(mainViewController, sender: nil)
    }

    // Remove the listener once it's no longer needed
 
}
