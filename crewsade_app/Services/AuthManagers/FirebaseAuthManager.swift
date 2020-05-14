//
//  FirebaseAuthManager.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 01/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseStorage

class FirebaseAuthManager: UIViewController{
    let db = Firestore.firestore()
    let storage = Storage.storage()
    lazy var storageRef = storage.reference()
    
    func createUser(username: String, Image: UIImage,email: String, password: String,view: SignUpViewController, completionBlock: @escaping (_ success: Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if error != nil{
                if let error = error{
                    self.handleError(error, view: view)
                    completionBlock(false)
                }
            }
            
            if let user = authResult?.user {
                self.setProfile(username: username,user: user,Image: Image){[weak self] (success) in
                    guard let `self` = self else { return }
                    if (success) {
                        completionBlock(true)
                    } else {
                        print("Error")
                    }
                }
            }
        }
    }
    func setProfile(username: String,user: Firebase.User, Image: UIImage,completionBlock: @escaping (_ success: Bool) -> Void){
        let profilePictureStorageRef = self.storageRef.child("user_profiles/\(user.uid)/profile_picture")
        
        guard let imageData = Image.jpegData(compressionQuality: 0.4) else{ return}
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        profilePictureStorageRef.putData(imageData, metadata: metadata){(metadata, error) in
            if(error == nil){
                profilePictureStorageRef.downloadURL(completion: {(url,error) in
                    if let url = url{
                        self.db.collection("users").document(user.uid).setData([
                            "Username": username,
                            "Image": url.absoluteString
                        ])
                    }
                })
                
                completionBlock(true)
            }
            else{
                print(error?.localizedDescription)
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
    func resetPassword(email:String,completionBlock: @escaping (_ success: Bool) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil{
                if let error = error{
                    completionBlock(false)
                }
            }
            completionBlock(true)
        }
    }
    
    func handleError(_ error: Error, view: SignUpViewController) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            // now you can use the .errorMessage var to get your custom error message
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            view.present(alert, animated: true, completion: nil)
        }
    }
    
}






