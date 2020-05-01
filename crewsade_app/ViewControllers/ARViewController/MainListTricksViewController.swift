//
//  MainListTricksViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 01/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MainListTricksViewController: UIViewController {
    
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser!.uid
    
    var tricks = [String]()
    
    @IBOutlet weak var mainListTricksTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainListTricksTable.dataSource = self
        mainListTricksTable.delegate = self

        // Do any additional setup after loading the view.
        
        
        db.collection("users").document(userID).collection("tricks").getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in querySnapshot!.documents {
                        
                         let trick = document.get("Trick") as! DocumentReference

                         trick.getDocument { (documentSnapshot, err) in
                             if let err = err{
                                 print("Error getting documents: \(err)")
                             }
                             else{
                                 if let trick = documentSnapshot{
                                     let trickData = trick.data()
                                     let trickName = trickData?["Name"] as! String
                                    self.tricks.append(trickName)
                                    self.mainListTricksTable.reloadData()
                                 }
                             }
                         }
                     }
                 }
             }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainListTricksViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tricks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        
        
        cell.textLabel?.text = tricks[indexPath.row]
        
        return cell
    }
    
}

extension MainListTricksViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
      
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
