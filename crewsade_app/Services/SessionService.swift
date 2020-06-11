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
import Firebase

class SessionService{

    let db = Firestore.firestore()
    var i:Double = 1
    let user = Auth.auth().currentUser
    
    func getSession(completionHandler: @escaping (_ sessionId: String) -> Void){
        if let user = user{
            self.db.collection("users").document(user.uid).getDocument{(document, error) in
                if let userData = document, document!.exists{
                    if let challenge = userData.get("challenge") as? [String: Any]{
                        if let sessionId = challenge["referenceId"] as? String{
                            completionHandler(sessionId)
                        }
                    }
                }
            }
        }
    }
    
    func beginner(sessionId: String){
        let random = Int.random(in: 0 ... 1)
        db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument{ (document, error) in
            if let document = document, document.exists {
                let player1 = document.get("Player1") as? [String: Any]
                let player2 = document.get("Player2") as? [String: Any]
                var isPlayed: String = ""
                switch random {
                case 0:
                    if let player1 = player1{
                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData([
                            "isPlayed": player1["UserId"] as! String
                        ])
                        isPlayed = player1["UserId"] as! String
                    }
                    break
                default:
                    if let player2 = player2{
                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData([
                            "isPlayed": player2["UserId"] as! String
                        ])
                        isPlayed = player2["UserId"] as! String
                    }
                }
                if let player1 = player1{
                    if let player2 = player2{
                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Round":
                            [
                                "step": 1,
                                player1["UserId"] as! String: 0,
                                player2["UserId"] as! String: 0,
                                "isPlayed": isPlayed,
                                "i": 0
                            ]
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
        getSession(){sessionId in
            self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).addSnapshotListener(){ (result, error) in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    if let result = result {
                        if let isPlayed = result.get("isPlayed") as? String {
                            if userId == isPlayed{
                                completionHandler(userId)
                            }
                            else{
                                completionHandler("Nop")
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func getChallengerInformations(completionHandler: @escaping (_ success: User?) -> Void){
        if let user = user{
            self.db.collection("users").document(user.uid).getDocument{(document, error) in
                if let userData = document, document!.exists{
                    if let challenge = userData.get("challenge") as? [String: Any]{
                        if let challenger = challenge["challenger"] as? String{
                            self.db.collection("users").document(challenger).getDocument{(document, error) in
                                if let challengerData = document, document!.exists{
                                    let stats = challengerData.get("Stats") as! [String: Int]
                                    if let name = challengerData.get("Username") as? String, let image = challengerData.get("Image") as? String{
                                        completionHandler(User(username: name, image: URL(string:image), id: challenger,stats: stats ))
                                    }
                                }
                                else{
                                    completionHandler(nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func trickIsValidate(){
        if let user = user {
            self.getSession(){sessionId in
                self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Round.i": FieldValue.increment(Int64(1))])
                self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["isPlayed": user.uid])
            }
        }
    }
    
    func trickIsDeny(){
        if let user = user{
            self.getSession(){sessionId in
                self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument{ (document, error) in
                    if let document = document, document.exists {
                        if let isPlayed = document.get("isPlayed") as? String {
                            if let Player1 = document.get("Player1") as? [String: Any] {
                                let idPlayer1 = Player1["UserId"] as! String
                                
                                if let Player2 = document.get("Player2") as? [String: Any]{
                                    let idPlayer2 = Player2["UserId"] as! String
                                    
                                    self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Round.\(isPlayed)":1])
                                    self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Round.i":FieldValue.increment(Int64(1))])
                                    self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["isPlayed": user.uid])
                                    
                                    
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
    
    func updateRound(){
        if let user = user{
            self.getSession(){sessionId in
                self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument{ (document, error) in
                    if let document = document, document.exists {
                        if let isPlayed = document.get("isPlayed") as? String {
                            if let Player1 = document.get("Player1") as? [String: Any] {
                                let idPlayer1 = Player1["UserId"] as! String
                                
                                if let Player2 = document.get("Player2") as? [String: Any]{
                                    let idPlayer2 = Player2["UserId"] as! String
                                    
                                    if let round = document.get("Round") as? [String: Any]{
                                        let step = round["step"] as! Double
                                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Round":
                                            [ idPlayer1: 0,
                                              idPlayer2: 0,
                                              "step": step + 0.5,
                                              "isPlayed": isPlayed,
                                              "i": 0
                                            ]
                                        ])
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
    
    func setRound(view: UIViewController){
        if let user = user{
            self.db.collection("users").document(user.uid).getDocument{(document, error) in
                if let userData = document, document!.exists{
                    if let challenge = userData.get("challenge") as? [String: Any]{
                        let challenger = challenge["challenger"] as! String
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
                                if let round =  data["Round"] as? [String: Any]{
                                    let i = round["i"] as! Int
                                    let step = round["step"] as! Double
                                    let isPlayed = round["isPlayed"] as! String
                                    let me = round[user.uid] as! Int
                                    let him = round[challenger] as! Int
                                    
                                    if i == 2 && self.i == step{
                                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Round.i": 0 ])
                                        if me == 0 && him == 0{
                                            print("rien")
                                        }
                                        if me == 1 && him == 0{
                                            if let Player1 = document.get("Player1") as? [String: Any] {
                                                let idPlayer1 = Player1["UserId"] as! String
                                                let scorePlayer1 = Player1["Score"] as! Int
                                                if let Player2 = document.get("Player2") as? [String: Any]{
                                                    let idPlayer2 = Player2["UserId"] as! String
                                                    let scorePlayer2 = Player2["Score"] as! Int
                                                    switch user.uid {
                                                    case idPlayer1:
                                                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Player1":[
                                                            "UserId": idPlayer1,
                                                            "Score": scorePlayer1 - 1
                                                            ],
                                                                                                                                                           "isPlayed": idPlayer2])
                                                        
                                                        break
                                                    default:
                                                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Player2":[
                                                            "UserId": idPlayer2,
                                                            "Score": scorePlayer2 - 1
                                                            ],"isPlayed": idPlayer1 ])
                                                        
                                                        
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                        
                                        if me == 0 && him == 1{
                                            if let Player1 = document.get("Player1") as? [String: Any] {
                                                let idPlayer1 = Player1["UserId"] as! String
                                                let scorePlayer1 = Player1["Score"] as! Int
                                                if let Player2 = document.get("Player2") as? [String: Any]{
                                                    let idPlayer2 = Player2["UserId"] as! String
                                                    let scorePlayer2 = Player2["Score"] as! Int
                                                    
                                                    switch challenger {
                                                    case idPlayer1:
                                                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Player1":[
                                                            "UserId": idPlayer1,
                                                            "Score": scorePlayer1 - 1
                                                            ],
                                                                                                                                                           "isPlayed": idPlayer2])
                                                        
                                                        break
                                                    default:
                                                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Player2":[
                                                            "UserId": idPlayer2,
                                                            "Score": scorePlayer2 - 1
                                                            ],"isPlayed": idPlayer1 ])
                                                        
                                                        
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                        if me == 1 && him == 1{
                                            if let Player1 = document.get("Player1") as? [String: Any] {
                                                let idPlayer1 = Player1["UserId"] as! String
                                                
                                                if let Player2 = document.get("Player2") as? [String: Any]{
                                                    let idPlayer2 = Player2["UserId"] as! String
                                                    
                                                    switch isPlayed {
                                                    case idPlayer1:
                                                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["isPlayed": idPlayer2])
                                                        
                                                        break
                                                    default:
                                                        self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["isPlayed": idPlayer1 ])
                                                        
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                        self.i += 1
                                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                                        let mainViewController = mainStoryboard.instantiateViewController(identifier: "round")
                                        view.show(mainViewController, sender: nil)
                                    }
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
    
    func getPlayersDataGames(completionHandler: @escaping (_ result: Session) -> Void){
        if let user = user{
            self.db.collection("users").document(user.uid).getDocument{(document, error) in
                if let user = document, document!.exists{
                    if let challenge = user.get("challenge") as? [String: Any]{
                        if let sessionId = challenge["referenceId"] as? String{
                            self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument(){ (result, error) in
                                if let error = error{
                                    print(error.localizedDescription)
                                }else{
                                    if let result = result, result.exists {
                                        if let player1 =  result["Player1"] as? [String: Any]{
                                            let idPlayer1 = player1["UserId"] as! String
                                            let scorePlayer1 = player1["Score"] as! Int
                                            
                                            if let player2 = result["Player2"] as? [String: Any]{
                                                let idPlayer2 = player2["UserId"] as! String
                                                
                                                let scorePlayer2 = player2["Score"] as! Int
                                                
                                                if let round = result["Round"] as? [String: Any]{
                                                    let step = round["step"] as! Double
                                                    UserService().getUserInformations(id: idPlayer1){ result in
                                                        if let user1 = result {
                                                            
                                                            UserService().getUserInformations(id: idPlayer2){ result in
                                                                if let user2 = result {
                                                                    
                                                                    completionHandler(Session(player1: User(username: user1.username, image: user1.image, id: user1.id, stats: user1.stats, score: scorePlayer1), player2: User(username: user2.username, image: user2.image, id: user2.id, stats: user2.stats, score: scorePlayer2), roundStep: step))
                                                                    
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
                    }
                }
            }
        }
    }
    
    func checkIsWin(completionHandler: @escaping (_ result: String) -> Void){
        if let user = user{
            self.db.collection("users").document(user.uid).getDocument{(document, error) in
                if let user = document, document!.exists{
                    if let challenge = user.get("challenge") as? [String: Any]{
                        if let sessionId = challenge["referenceId"] as? String{
                            self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument(){ (result, error) in
                                if let error = error{
                                    print(error.localizedDescription)
                                }else{
                                    if let result = result, result.exists {
                                        
                                        let winner = result["Winner"] as? String
                                        
                                        if winner == nil{
                                            if let player1 =  result["Player1"] as? [String: Any]{
                                                let idPlayer1 = player1["UserId"] as! String
                                                let scorePlayer1 = player1["Score"] as! Int
                                                
                                                if let player2 = result["Player2"] as? [String: Any]{
                                                    let idPlayer2 = player2["UserId"] as! String
                                                    
                                                    let scorePlayer2 = player2["Score"] as! Int
                                                    
                                                    if scorePlayer1 == 0 {
                                                        
                                                        UserService().getUserInformations(id: idPlayer2){userData in
                                                            if let userData = userData{
                                                                self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Winner": userData.username])
                                                            }
                                                            
                                                        }
                                                        print("id: \(idPlayer2)")
                                                        completionHandler(idPlayer2)
                                                    }
                                                    if scorePlayer2 == 0{
                                                        UserService().getUserInformations(id: idPlayer1){userData in
                                                            if let userData = userData{
                                                                self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).updateData(["Winner": userData.username])
                                                            }
                                                            
                                                        }
                                                        print("id: \(idPlayer1)")
                                                        completionHandler(idPlayer1)
                                                        
                                                    }
                                                    if scorePlayer1 != 0 && scorePlayer2 != 0{
                                                        completionHandler("don't finish")
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
        }
    }
    
    func displayWinner(completionHandler: @escaping (_ winner: String) -> Void){
        if let user = user{
            self.getSession(){sessionId in
                self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).getDocument{(document, error) in
                    if let session = document, document!.exists{
                        if let winner = session.get("Winner") as? String{
                            completionHandler(winner)
                        }
                    }
                }
            }
        }
    }
    
    func endSession(){
        if let user = user{
            self.getSession(){sessionId in
                self.db.collection("games").document("OUT").collection("Sessions").document(sessionId).delete() { err in
                    if let err = err {
                        print("Document doesn't exist: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                self.db.collection("users").document(user.uid).updateData(["challenge": FieldValue.delete()]) {  err in
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
