//
//  UserService.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 04/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
class UserService {
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let storage = Storage.storage()
    lazy var storageRef = storage.reference()
    var tricks = [Trick]()
    
    
    func setProfile(username: String, Image: UIImage,completionHandler: @escaping (_ success: Bool) -> Void){
        if let user = user {
            let profilePictureStorageRef = storageRef.child("user_profiles/\(user.uid)/profile_picture")
            
            guard let imageData = Image.jpegData(compressionQuality: 0.4) else{ return}
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            profilePictureStorageRef.putData(imageData, metadata: metadata){(metadata, error) in
                if(error == nil){
                    profilePictureStorageRef.downloadURL(completion: {(url,error) in
                        if let metaImageUrl = url?.absoluteString{
                            self.db.collection("users").document(user.uid).setData([
                                "Username": username,
                                "ProfileImage": metaImageUrl
                            ])
                        }
                    })
                    completionHandler(true)
                }
                else{
                    print(error?.localizedDescription)
                    completionHandler(false)
                }
            }
        }
    }
    
    func saveTrick(trick: DocumentReference){
        if let user = user {
            trick.getDocument{(DocumentSnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                }
                else{
                    if let trickData = DocumentSnapshot{
                        self.db.collection("users").document(user.uid).collection("tricks").document(trickData.get("Name") as! String).setData([
                            "Trick": trick,
                            "Status": "None"
                        ])
                    }
                }
                
            }
        }
    }
    
    func deleteTrick(trick: DocumentReference){
        if let user = user {
            trick.getDocument{(DocumentSnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                }
                else{
                    if let trickData = DocumentSnapshot{
                        self.db.collection("users").document(user.uid).collection("tricks").document(trickData.get("Name") as! String).delete()
                    }
                }
            }
        }
    }
    
    func getTricksSaved(completionHandler: @escaping (_ result: [Trick]?) -> Void){
        let group = DispatchGroup()
        if let user = user{
            db.collection("users").document(user.uid).collection("tricks").addSnapshotListener { DocumentSnapshot, err in
                guard let collection = DocumentSnapshot else{
                    print("Error fetching document: \(err!)")
                    return
                }
                self.tricks = [Trick]()
                for document in collection.documents {
                    group.enter()
                    let trick = document.get("Trick") as! DocumentReference
                    
                    trick.getDocument { (documentSnapshot, err) in
                        if let err = err{
                            print("Error getting documents: \(err)")
                        }
                        else{
                            if let trick = documentSnapshot{
                                let trickData = trick.data()
                                let trickName = trickData?["Name"] as? String
                                let trickContent = trickData?["Content"] as? String
                                let trickLevel = trickData?["Level"] as? String
                                let reference = trick.reference
                                
                                self.tricks.append(Trick(name: trickName, content: trickContent, level: trickLevel, reference: reference))
                                group.leave()
                                
                            }
                        }
                    }
                }
                
                
                group.notify(queue: .main, execute: {
                    completionHandler(self.tricks)
                })
            }
        }
    }
}
