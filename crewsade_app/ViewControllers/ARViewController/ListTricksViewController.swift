//
//  ListTricksViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 27/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ListTricksViewController: UIViewController {

    let db = Firestore.firestore()
    var tricksDisplay = [Trick]()
    var tricksGet = [Trick]()
    var levelName:String?

    @IBOutlet weak var ListTricksTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListTricksTable.delegate = self
        ListTricksTable.dataSource = self

        // Do any additional setup after loading the view.
        getTricks()
    }
    
   private func getTricks(){
        db.collection("tricks").getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in querySnapshot!.documents {
                         
                         let level = document.get("Level") as! DocumentReference
                         let name = document.get("Name") as! String
                         let content = document.get("Content") as! String

                         level.getDocument { (documentSnapshot, err) in
                             if let err = err{
                                 print("Error getting documents: \(err)")
                             }
                             else{
                                 if let level = documentSnapshot{
                                     self.levelName = level.data()?["Name"] as! String
                                     
                                     self.tricksGet.append(Trick(name: name, content: content, level: self.levelName))
                                     self.tricksDisplay = self.tricksGet
                                    
                                    self.ListTricksTable.reloadData()
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

extension ListTricksViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tricksDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTricksCell",for: indexPath) as! ListTricksTableViewCell
        
        switch indexPath.row % 2 {
        case 1:
            cell.contentView.backgroundColor = UIColor.CrewSade.darkGrey
            cell.trickName.textColor = UIColor.CrewSade.secondaryColorLight
            cell.trickLevel.textColor = UIColor.CrewSade.secondaryColorLight
            cell.trickContent.textColor = UIColor.CrewSade.secondaryColorLight
        default:
            cell.contentView.backgroundColor = UIColor.CrewSade.secondaryColorLight
        }
        cell.trickName.text = tricksDisplay[indexPath.row].name.uppercased()
        cell.trickContent.text = tricksDisplay[indexPath.row].content
        cell.trickLevel.text = tricksDisplay[indexPath.row].level?.uppercased()
        
        return cell
    }
    
}

extension ListTricksViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}


