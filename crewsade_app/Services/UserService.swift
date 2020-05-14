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
    
    var tricks = [Trick]()
    
    func getUserInformations(id: String, completionHandler: @escaping (_ result: User?) -> Void){
              self.db.collection("users").document(id).getDocument { (document, error) in
                  if let document = document, document.exists {
                      let username = document.get("Username") as? String
                    if let image = document.get("Image") as? String{
                        completionHandler(User(username: username, Image: URL(string:image), id: id))

                    }

                  } else {
                      print("User doesn't not exist")
                      completionHandler(nil)
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
    func logOut(view: UIViewController){
        do
          {
              try Auth.auth().signOut()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Sign", bundle: nil)
            let mainViewController = mainStoryboard.instantiateViewController(identifier: "SignView")
            view.show(mainViewController, sender: nil)
          }
          catch let error as NSError
          {
              print(error.localizedDescription)
          }
    }
}
