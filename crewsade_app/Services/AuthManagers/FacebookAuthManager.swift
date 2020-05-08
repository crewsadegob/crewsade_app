//
//  FacebookAuthManager.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 08/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class FacebookAuthManager {
    let loginManager = LoginManager()

      
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
                          let mainStoryboard: UIStoryboard = UIStoryboard(name: "SetProfileInformation", bundle: nil)
                          let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
                          viewController.show(mainViewController, sender: nil)
                      }
                  }
              }
          }
      }
}
