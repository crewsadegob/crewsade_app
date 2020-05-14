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
    var players = [User]()
    
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
                        
                        players.append(User(username: name, Image: imageUrl, id: id))
                    }
                    group.leave()
                    
                }
                group.notify(queue: .main, execute: {
                    completionHandler(players)
                })
            }
        }
    }
    
    func checkIsUserChallenged(view: ViewController){
        if let user = user{
            db.collection("users").document(user.uid).addSnapshotListener() { (player, err) in
                if let err = err {
                    print("Problème pour l'event: \(err)")
                } else {
                    if let player = player {
                        if let isChallenged = player.get("challenged") as? Bool{
                            if isChallenged{
                                let challengeNotification = UIAlertController(title: "Défi OUT", message: "On te défie", preferredStyle: UIAlertController.Style.actionSheet)
                                
                                challengeNotification.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action:UIAlertAction) in
                                    
                                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                                    let mainViewController = mainStoryboard.instantiateViewController(identifier: "StartChallenge")
                                    view.show(mainViewController, sender: nil)
                                    
                                }))
                                
                                challengeNotification.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: {(action:UIAlertAction) in
                                }))
                                
                                view.present(challengeNotification, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func createSession(player1: String,player2: String, state: Bool, view: UIViewController){
        let UsersId = [player1,player2]
        
        for userId in UsersId{
            UserService().getUserInformations(id: userId){result in
                if let user = result{
                    self.players.append(User(username: user.username, Image: user.Image, id: user.id))
                }
                
            }
        }
        
        self.db.collection("users").document(player1).updateData(["challenged": state]) {  err in
            if let err = err {
                print("Problème pour l'event: \(err)")
            } else {
                print("Tu as bien défié : \(player1)")
                self.db.collection("games").document("OUT").collection("Sessions").document().setData([
                    "Player1": [
                        "Username": self.players[0].username,
                        "UserId": self.players[0].id,
                        "Score": 3
                    ],
                    "Player2":[
                        "Username": self.players[1].username,
                        "UserId": self.players[1].id,
                        "Score": 3
                    ]
                ])
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = mainStoryboard.instantiateViewController(identifier: "StartChallenge")
                view.show(mainViewController, sender: nil)
                
            }
        }
    }
    
    
    func test(){
        db.collection("games").document("OUT").collection("Sessions").addSnapshotListener(){ (players, error) in
            if error == nil{
                print(players?.documentChanges)
            }
            print(error)
            
        }
    }
}

