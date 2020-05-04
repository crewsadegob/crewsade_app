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
import FirebaseAuth

class ListTricksViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var tricksDisplay = [Trick]()
    var tricksGet = [Trick]()
    let userID = Auth.auth().currentUser!.uid
    var buttonX:Int = 30
    let buttonY:Int = 0
    let buttonWidth = 63
    let buttonHeight = 50
    
    @IBOutlet weak var ButtonSection: UIStackView!
    @IBOutlet weak var ListTricksTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonSection.addBackground(color: UIColor.CrewSade.darkGrey)
        ListTricksTable.delegate = self
        ListTricksTable.dataSource = self
        // Do any additional setup after loading the view.
        
        TrickService().getTricks(){ result in
            if let tricks = result{
                self.tricksDisplay = tricks
                self.ListTricksTable.reloadData()
            }
        }
        LevelService().getLevels(){ result in
            if let level = result{
                
                let button = UIButton(type: .system)
                
                button.frame = CGRect(x: self.buttonX, y: self.buttonY, width: self.buttonWidth, height: self.buttonHeight)
                
                button.setTitle(level.uppercased(), for: .normal)
                button.titleLabel?.font = UIFont(name: "Polly-Regular", size: 9)
                button.tintColor = UIColor.CrewSade.secondaryColorLight
                
                self.buttonX += self.buttonWidth
                button.addTarget(self, action: #selector(self.levelClicked(_:)), for: .touchUpInside)
                self.ButtonSection.addSubview(button)
            }
            
        }
}

    @objc private func levelClicked(_ sender: UIButton) {
        let buttons = ButtonSection.subviews.filter{$0 is UIButton}
        for button in buttons{
            button.tintColor = UIColor.CrewSade.secondaryColorLight
        }
        
        sender.tintColor = UIColor.CrewSade.mainColor
        let tricksCloned = tricksGet
        let tricksFiltering = tricksCloned.filter{ $0.level?.lowercased() == sender.titleLabel?.text?.lowercased()}
        
        tricksDisplay = tricksFiltering
        ListTricksTable.reloadData()
    }
    
    @objc private func buttonSaveClicked(_ sender: UIButton){
        sender.setImage(UIImage(named: "saveFull"), for: .normal)
        self.db.collection("users").document(userID).collection("tricks").addDocument(data:[
            "Trick": tricksDisplay[sender.tag].reference,
            "Status": "None"
        ])
    }
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
        cell.trickName.text = tricksDisplay[indexPath.row].name?.uppercased()
        cell.trickContent.text = tricksDisplay[indexPath.row].content
        cell.trickLevel.text = tricksDisplay[indexPath.row].level?.uppercased()
        cell.saveButton.tag = indexPath.row
        cell.saveButton.addTarget(self, action: #selector(buttonSaveClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
}

extension ListTricksViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tricksDisplay[indexPath.row].reference)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}


