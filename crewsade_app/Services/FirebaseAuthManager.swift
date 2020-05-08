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
import FirebaseStorage

class FirebaseAuthManager{
    let db = Firestore.firestore()
    let loginManager = LoginManager()
    let storage = Storage.storage()
    lazy var storageRef = storage.reference()
    
    
    func createUser(username: String, Image: UIImage,email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                let changeRequest = user.createProfileChangeRequest()
                
                let profilePictureStorageRef = self.storageRef.child("user_profiles/\(user.uid)/profile_picture")
                
                guard let imageData = Image.jpegData(compressionQuality: 0.4) else{ return}
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                profilePictureStorageRef.putData(imageData, metadata: metadata){(metadata, error) in
                    if(error == nil){
                        profilePictureStorageRef.downloadURL(completion: {(url,error) in
                            if let url = url{
                                changeRequest.photoURL = url
                                changeRequest.commitChanges { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("User updated")
                                    }
                                }
                            }
                        })
                        self.db.collection("users").document(user.uid).setData([
                            "Username": username
                        ])
                    }
                    else{
                        print(error?.localizedDescription)
                    }
                }
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
