//
//  GamesService.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 12/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import Firebase

class GamesService {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    
    func getPlayers(completionHandler: @escaping (_ result: [User]?) -> Void){
        let group = DispatchGroup()
        db.collection("users").addSnapshotListener() { (users, err) in
            if let err = err {
                print("Problème pour charger les tricks: \(err)")
                completionHandler(nil)
            } else {
                var players = [User]()
                for user in users!.documents {
                    group.enter()
                    let name = user.get("Username") as? String
                    let id = user.documentID
                    if let image = user.get("Image") as? String{
                        let imageUrl = URL(string: image)
                        
                        self.players.append(User(username: name, Image: imageUrl, id: id))
                    }
                    group.leave()
                    
                }
                group.notify(queue: .main, execute: {
                    completionHandler(self.players)
                })
            }
        }
    }
    
    func checkIsUserChallenged(){
        if let user = user{
            db.collection("users").document(user.uid).addSnapshotListener() { (player, err) in
                if let err = err {
                    print("Problème pour l'event: \(err)")
                } else {
                    if let player = player {
                        if let isChallenged = player.get("challenged") as? Bool{
                            if isChallenged{
                                print("On te défie")
                            }
                            print("check")
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    
    func challengedUser(userId: String){
        db.collection("users").document(userId).updateData(["challenged": true]) {  err in
            if let err = err {
                print("Problème pour l'event: \(err)")
            } else {
                print("Tu as bien défié : \(userId)")
            }
        }
    }
    
}
