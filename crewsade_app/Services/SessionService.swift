//
//  SessionService.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import Firebase
class SessionService{

    let db = Firestore.firestore()
    var session: String?
    func beginner(sessionId: String){
        session = sessionId
        let random = Int.random(in: 0 ... 1)
        print(random)
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
        
            if let session = session{
                db.collection("games").document("OUT").collection("Sessions").document(session).getDocument{ (document, error) in
                    if let document = document, document.exists {
                        print(document)

                        if let isPlayed = document.get("isPlayed") as? String {
                            if userId == isPlayed{
                                completionHandler(userId)
                            }
                            else{
                                completionHandler(userId)
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
