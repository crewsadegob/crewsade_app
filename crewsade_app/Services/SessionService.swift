//
//  SessionService.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
class SessionService{
    
    let db = Firestore.firestore()
    var i:Int = 0
    let user = Auth.auth().currentUser
    
    func beginner(sessionId: String){
        let random = Int.random(in: 0 ... 1)
        db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument{ (document, error) in
            if let document = document, document.exists {
                let player1 = document.get("Player1") as? [String: Any]
                let player2 = document.get("Player2") as? [String: Any]
                
                switch random {
                case 0:
                    if let player1 = player1{
                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData([
                            "isPlayed": player1["UserId"] as! String
                        ])
                    }
                    break
                default:
                    if let player2 = player2{
                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData([
                            "isPlayed": player2["UserId"] as! String
                        ])
                    }
                }
            }
            else {
                print("User doesn't not exist")
            }
        }
    }
    
    
    func setViewPlayer(userId: String,completionHandler: @escaping (_ result: String) -> Void){
        if(i < 1){
            self.db.collection("users").document(userId).getDocument{(document, error) in
                if let user = document, document!.exists{
                    if let challenge = user.get("challenge") as? [String: Any]{
                        if let sessionId = challenge["referenceId"] as? String{
                            self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument{ (document, error) in
                                if let document = document, document.exists {
                                    
                                    if let isPlayed = document.get("isPlayed") as? String {
                                        if userId == isPlayed{
                                            completionHandler(userId)
                                            self.i += 1
                                        }
                                        else{
                                            completionHandler("Zoulou")
                                        }
                                    }
                                    
                                }
                                else {
                                    print("User doesn't not exist")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func trickIsValidate(completionHandler: @escaping (_ success: Bool) -> Void){
        if let user = user{
            self.db.collection("users").document(user.uid).getDocument{(document, error) in
                if let user = document, document!.exists{
                    if let challenge = user.get("challenge") as? [String: Any]{
                        if let sessionId = challenge["referenceId"] as? String{
                            self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["isPlayed": challenge["challenger"] as! String]){err in
                                if let error = err{
                                    print(error.localizedDescription)
                                    completionHandler(false)
                                }else{
                                    print("Document modified")
                                    completionHandler(true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func trickIsDeny(completionHandler: @escaping (_ success: Bool) -> Void){
        if let user = user{
            self.db.collection("users").document(user.uid).getDocument{(document, error) in
                if let user = document, document!.exists{
                    if let challenge = user.get("challenge") as? [String: Any]{
                        if let sessionId = challenge["referenceId"] as? String{
                            self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument{ (document, error) in
                                if let document = document, document.exists {
                                    if let isPlayed = document.get("isPlayed") as? String {
                                        if let Player1 = document.get("Player1") as? [String: Any] {
                                            let idPlayer1 = Player1["UserId"] as! String
                                            let scorePlayer1 = Player1["Score"] as! Int
                                            
                                            if let Player2 = document.get("Player2") as? [String: Any]{
                                                let idPlayer2 = Player2["UserId"] as! String
                                                let scorePlayer2 = Player2["Score"] as! Int
                                                
                                                
                                                switch isPlayed {
                                                case idPlayer1:
                                                    self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Player1":[
                                                        "UserId": idPlayer1,
                                                        "Score": scorePlayer1 - 1
                                                        ],
                                                                                                                                                       "isPlayed": idPlayer2])
                                                    completionHandler(true)
                                                    break
                                                default:
                                                    self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Player2":[
                                                        "UserId": idPlayer2,
                                                        "Score": scorePlayer2 - 1
                                                        ],"isPlayed": idPlayer2 ])
                                                    
                                                    completionHandler(true)
                                                    break
                                                }
                                                
                                                
                                            }
                                        }
                                    }
                                }
                                else {
                                    print("User doesn't not exist")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func manageScore(completionHandler: @escaping (_ result: Int) -> Void){
        if let user = user{
            self.db.collection("users").document(user.uid).getDocument{(document, error) in
                if let player = document, document!.exists{
                    if let challenge = player.get("challenge") as? [String: Any]{
                        if let sessionId = challenge["referenceId"] as? String{
                            self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).addSnapshotListener{ documentSnapshot, error in
                                guard let document = documentSnapshot else {
                                    print("Error fetching document: \(error!)")
                                    return
                                }
                                guard let data = document.data() else {
                                    print("Document data was empty.")
                                    return
                                }
                                if let player1 =  data["Player1"] as? [String: Any]{
                                    let idPlayer1 = player1["UserId"] as! String
                                    let scorePlayer1 = player1["Score"] as! Int
                                    
                                    if let Player2 = data["Player2"] as? [String: Any]{
                                        let scorePlayer2 = Player2["Score"] as! Int
                                        
                                        
                                        switch user.uid {
                                        case idPlayer1:
                                                completionHandler(scorePlayer1)
                                            break
                                        default:
                                            completionHandler(scorePlayer2)
                                            break
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
