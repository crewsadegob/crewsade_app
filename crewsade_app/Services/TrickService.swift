//
//  TrickService.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 04/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseFirestore

class TrickService {
    
    let db = Firestore.firestore()
    var Tricks = [Trick]()
    var CompareTricks = [Trick]()
    
    func getTricks(completionHandler: @escaping (_ result: [Trick]?) -> Void){
        let group = DispatchGroup()
        db.collection("tricks").addSnapshotListener() { (tricks, err) in
            if let err = err {
                print("Problème pour charger les tricks: \(err)")
                completionHandler(nil)
            } else {
                for trick in tricks!.documents {
                    group.enter()
                    let reference = trick.reference
                    
                    let levelReference = trick.get("Level") as! DocumentReference
                    let  name = trick.get("Name") as? String
                    let content = trick.get("Content") as? String
                    
                    
                    levelReference.getDocument { (documentSnapshot, err) in
                        if let err = err{
                            print("Problème pour récupérer le level: \(err)")
                        }
                        else{
                            if let levelData = documentSnapshot{
                                let level = levelData.data()?["Name"] as? String
                                
                                self.Tricks.append(Trick(name: name, content: content, level: level,reference: reference))
                                group.leave()
                            }
                        }
                    }
                }
                
                group.notify(queue: .main, execute: {
                    completionHandler(self.Tricks)
                })
            }
        }
    }
    func compareSavedTricksAndListTricks(completionHandler: @escaping (_ result: [Trick]?) -> Void){
        getTricks(){ result in
            if var allTricks = result{
                UserService().getTricksSaved(){ result in
                    if  let tricksSaved = result{
                        for trickSaved in tricksSaved {
                            for (index, trick) in allTricks.enumerated(){
                                if let trickSavedReference = trickSaved.reference{
                                    if trick.reference == trickSavedReference{
                                        allTricks[index].saved = true
                                    }
                                }
                            }
                        }
                    }
                    self.CompareTricks = allTricks
                    completionHandler(self.CompareTricks)
                }
            }
        }
    }
}
