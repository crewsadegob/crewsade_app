//
//  GoogleAuthManager.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 08/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Firebase
import FirebaseFirestore
import GoogleSignIn

class GoogleAuthManager:NSObject, GIDSignInDelegate {
    let viewController: SignInViewController
     init(view: SignInViewController) {
        self.viewController = view
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {


    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
   
}
