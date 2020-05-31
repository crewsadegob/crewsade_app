//
//  GamesService.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 12/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class GamesService {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var players = [User]()
    var i = 0

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
                    let stats = user.get("Stats") as! [String: Int]
                    let id = user.documentID
                    if let image = user.get("Image") as? String{
                        let imageUrl = URL(string: image)
                        
                        players.append(User(username: name, Image: imageUrl, id: id,stats: stats))
                    }
                    group.leave()
                    
                }
                group.notify(queue: .main, execute: {
                    completionHandler(players)
                })
            }
        }
    }
    
    func checkIsUserChallenged(view: UIViewController){
        if let user = user{
            db.collection("users").document(user.uid).addSnapshotListener() { (player, err) in
                if let err = err {
                    print("Problème pour l'event: \(err)")
                } else {
                    if let player = player {
                        if let challengeData = player.get("challenge") as? [String: Any]{
                            if let state = challengeData["state"] as? Bool{
                                if state{
                                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                                    let mainViewController = mainStoryboard.instantiateViewController(identifier: "challengeInvitation")
                                    view.show(mainViewController, sender: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func acceptChallenge(view: UIViewController){
        if let user = user{
            db.collection("users").document(user.uid).addSnapshotListener() { (player, err) in
                if let err = err {
                    print("Problème pour l'event: \(err)")
                } else {
                    if let player = player {
                        if let challengeData = player.get("challenge") as? [String: Any]{
                            if let state = challengeData["state"] as? Bool{
                                if state{
                                    if let refId = challengeData["referenceId"] as? String{
                                        self.db.collection("games").document("OUT").collection("Sessions").document(refId).updateData(["create": true]) { err in
                                            if let err = err {
                                                print("Error removing document: \(err)")
                                            } else {
                                                print("Document successfully update!")
                                                self.ChallengeStart(view: view, sessionId: refId)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func denyChallenge(view: UIViewController){
        if let user = user{
            db.collection("users").document(user.uid).addSnapshotListener() { (player, err) in
                if let err = err {
                    print("Problème pour l'event: \(err)")
                } else {
                    if let player = player {
                        if let challengeData = player.get("challenge") as? [String: Any]{
                            if let state = challengeData["state"] as? Bool{
                                if state{
                                    if let refId = challengeData["referenceId"] as? String{
                                        self.db.collection("games").document("OUT").collection("Sessions").document(refId).delete() { err in
                                            if let err = err {
                                                print("Error removing document: \(err)")
                                            } else {
                                                print("Document successfully removed!")
                                            }
                                        }
                                    }
                                    
                                    self.db.collection("users").document(user.uid).updateData(["challenge": FieldValue.delete()]) {  err in
                                        if let err = err {
                                            print("Problème pour l'event: \(err)")
                                        } else {
                                            print("Défi refusé")
                                        }
                                    }
                                    if let challenger = challengeData["challenger"] as? String {
                                        self.db.collection("users").document(challenger).updateData(["challenge": FieldValue.delete()]) {  err in
                                            if let err = err {
                                                print("Problème pour l'event: \(err)")
                                            } else {
                                                print("Défi refusé")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func createSession(player1: String,player2: String, state: Bool,view: UIViewController){
        let UsersId = [player1,player2]
        let referenceSession = self.db.collection("games").document("OUT").collection("Sessions").document()
        
        self.db.collection("users").document(player1).updateData(["challenge": ["state":state, "referenceId": referenceSession.documentID, "challenger": player2]]) {  err in
            if let err = err {
                print("Problème pour l'event: \(err)")
            } else {
                print("Tu as bien défié : \(player1)")
                referenceSession.setData([
                    "Player1": [
                        "UserId": UsersId[0],
                        "Score": 3
                    ],
                    "Player2":[
                        "UserId": UsersId[1],
                        "Score": 3
                    ],
                    "create": false
                ])
            }
        }
        self.db.collection("users").document(player2).updateData(["challenge": ["referenceId": referenceSession.documentID, "challenger": player1]]) {  err in
            if let err = err {
                print("Problème pour l'event: \(err)")
            } else {
                self.ChallengeStart(view: view, sessionId: referenceSession.documentID)
                print("Tu as bien défié : \(player1)")
            }
        }
    }
    
    
    func getInformationsChallenge(userId: String,completionHandler: @escaping (_ result: [User]?) -> Void){
        var playersArray = [User]()
        self.db.collection("users").document(userId).getDocument{(document, error) in
            if let user = document, document!.exists{
                if let challenge = user.get("challenge") as? [String: Any]{
                    if let sessionId = challenge["referenceId"] as? String{
                        let group =  DispatchGroup()
                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).addSnapshotListener{(players, err) in
                            if let player = players, players!.exists {
                                let dataPlayer1 = player.get("Player1") as? [String: Any]
                                let dataPlayer2 = player.get("Player2") as? [String: Any]
                                
                                let playersId = [dataPlayer1!["UserId"] as! String, dataPlayer2!["UserId"] as! String]
                                
                                for playerId in playersId{
                                    group.enter()
                                    UserService().getUserInformations(id: playerId){result in
                                        if let user = result{
                                            playersArray.append(User(username: user.username, Image: user.Image, id: user.id,stats: user.stats))
                                            group.leave()
                                        }
                                    }
                                }
                                group.notify(queue: .main, execute: {
                                    completionHandler(playersArray)
                                })
                                
                            } else {
                                print("Document does not exist")
                                completionHandler(nil)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func ChallengeStart(view: UIViewController, sessionId: String){
        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).addSnapshotListener() { (session, err) in
            if let err = err {
                print("Problème pour l'event: \(err)")
            }
            else{
                if let session = session{
                    if let state = session.get("create") as? Bool{
                        if state && self.i == 0{
                            self.i += 1
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                            let mainViewController = mainStoryboard.instantiateViewController(identifier: "gameStart")
                            view.show(mainViewController, sender: nil)
                            
                            SessionService().beginner(sessionId: sessionId)
                        }
                    }
                }
            }
        }
    }
}

