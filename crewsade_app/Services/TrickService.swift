//
//  TrickService.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 04/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
class TrickService {
    let storage = Storage.storage()
    
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
                    let scene = trick.get("Scene") as? String
                    
                    
                    levelReference.getDocument { (documentSnapshot, err) in
                        if let err = err{
                            print("Problème pour récupérer le level: \(err)")
                        }
                        else{
                            if let levelData = documentSnapshot{
                                let level = levelData.data()?["Name"] as? String
                                
                                self.Tricks.append(Trick(name: name, content: content, level: level,reference: reference, scene: scene))
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
    
//    func getSceneTrick(trickScene: String?, completionHandler: @escaping (_ success: URL?) -> Void){
//        if let trickScene = trickScene {
//            let trickReference = storage.reference().child("tricks/HEELFLIP.dae")
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let sceneUrl = documentsURL.appendingPathComponent("scenes/")
//
////            let fileManager = FileManager.default
////            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
////            do {
////                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
////                print(fileURLs)
////                // process files
////            } catch {
////                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
////            }
//
//           trickReference.write(toFile: sceneUrl){ url, error in
//                if let error = error {
//                    print(error)
//                    completionHandler(nil)
//                } else{
//
//                    print("Scene télécharger: \(url)")
//                    completionHandler(url)
//                }
//            }
//
//
//
//
//
//
//
//
//
//        }
//    }
}
