//
//  LevelService.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 04/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseFirestore


class LevelService {
    
    let db = Firestore.firestore()
    
    func getLevels(completionHandler: @escaping (_ result: String?) -> Void){
        db.collection("level").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(nil)
            } else {
                for document in querySnapshot!.documents {
                    let name = document.get("Name") as? String
                    completionHandler(name)
                }
            }
        }
    }
}
