//
//  FirebaseAuthManager.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 01/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn


class FirebaseAuthManager{
    
    let db = Firestore.firestore()
    let loginManager = LoginManager()
    
    
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func signIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func googleLogin( _ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!,completionBlock: @escaping (_ success: Bool) -> Void){
          
        
        
    }
    
    func facebookLogin(_ sender: Any, viewController: UIViewController, completionBlock: @escaping (_ success: Bool) -> Void){
        if let sender = AccessToken.current {
            completionBlock(true)
            
        } else {
            loginManager.logIn(permissions: [], from: viewController) { [weak self] (result, error) in
                
                guard error == nil else {
                    // Error occurred
                    print(error!.localizedDescription)
                    completionBlock(false)
                    return
                }
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    completionBlock(false)
                    return
                }
                
                // Successfully logged in
                // 6
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completionBlock(false)
                        return
                    }
                    
                    Profile.loadCurrentProfile { (profile, error) in
                        if let name = Profile.current?.name{
                            if let user = authResult?.user{
                                self?.db.collection("users").document(user.uid).setData(["Username": Profile.current?.name])
                                completionBlock(true)
                            }
                        }
                    }
                }
            }
        }
    }
}
