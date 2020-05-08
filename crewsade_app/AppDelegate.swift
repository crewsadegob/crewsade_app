//
//  AppDelegate.swift
//  crewsade_app
//
//  Created by Lou Batier on 20/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    let barButtonAppareance = UINavigationBar.appearance()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )

        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let backImage = UIImage(named: "backItem")?.withRenderingMode(.alwaysOriginal)
          UINavigationBar.appearance().backIndicatorImage = backImage
          UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
          UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80.0), for: .default)
        
        return true
    }
    
    func application (_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        return GIDSignIn.sharedInstance().handle(url)

        
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
        let db = Firestore.firestore()

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
                    if let userSign = authResult?.user{
                        db.collection("users").document(userSign.uid).setData(["Username": user.profile.name])
                    }
                }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
        
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

