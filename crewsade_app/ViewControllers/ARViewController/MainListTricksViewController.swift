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
    
    var tricks = [Trick]()
    
    @IBOutlet weak var mainListTricksTable: UITableView!
    @IBOutlet weak var ctaButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ctaButton.layer.cornerRadius = 4.0
        ctaButton.addTextSpacing(6.0)
        mainListTricksTable.dataSource = self
        mainListTricksTable.delegate = self

        // Do any additional setup after loading the view.
        UserService().getTricksSaved(){ result in
            if let tricksSaved = result{
                self.tricks = tricksSaved
                self.mainListTricksTable.reloadData()

            }
        }
    }
    
}

extension MainListTricksViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tricks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainListTricksCell",for: indexPath) as! MainListTrickTableViewCell
        
        cell.nameLabel?.text = tricks[indexPath.row].name?.uppercased()
        
        return cell
    }
    
}

extension MainListTricksViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
