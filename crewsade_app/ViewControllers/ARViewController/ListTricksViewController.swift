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

class ListTricksViewController: ViewController {
    
// MARK: - VARIABLES
    
    @IBOutlet weak var ButtonSection: UIStackView!
    @IBOutlet weak var ListTricksTable: UITableView!
    
    let db = Firestore.firestore()
    var tricksDisplay = [Trick]()
    var tricksGet = [Trick]()
    var tricksSavedIndex = [Int]()
    var buttonX:Int = 0
    let buttonY:Int = 0
    let buttonWidth = 63
    let buttonHeight = 50
    
    var urlScene:String?
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ButtonSection.addBackground(color: UIColor.CrewSade.darkGrey)
        ListTricksTable.delegate = self
        ListTricksTable.dataSource = self
        TrickService().compareSavedTricksAndListTricks(){ result in
            if let tricks = result{
                print(tricks)
                self.tricksGet = tricks
                self.tricksDisplay = tricks
                self.ListTricksTable.rowHeight = UITableView.automaticDimension
                self.ListTricksTable.reloadData()
            }
        }
        
        LevelService().getLevels(){ result in
            if let level = result{
                
                let button = UIButton(type: .system)
                
                button.frame = CGRect(x: self.buttonX, y: self.buttonY, width: Int(self.ButtonSection.frame.size.width) / 5, height: Int(self.ButtonSection.frame.size.height))
                
                button.setTitle(level.uppercased(), for: .normal)
                button.titleLabel?.font = UIFont(name: "Polly-Regular", size: 9)
                button.tintColor = UIColor.CrewSade.secondaryColorLight
                
                self.buttonX += Int(self.ButtonSection.frame.size.width) / 5
                button.addTarget(self, action: #selector(self.levelClicked(_:)), for: .touchUpInside)
                self.ButtonSection.addSubview(button)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toARViewController"{
            if let dest = segue.destination as? ARViewController{
                if let indexPath = self.ListTricksTable.indexPathForSelectedRow{
                    
                    dest.trick = tricksDisplay[indexPath.row].name
                }
            }
        }
    }
    
// MARK: - ACTIONS
    
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
        if (tricksDisplay[sender.tag].saved){
            if let trickClicked = tricksDisplay[sender.tag].reference{
                UserService().deleteTrick(trick: trickClicked)
            }
        }
        else{
            if let trickClicked = tricksDisplay[sender.tag].reference{
                UserService().saveTrick(trick: trickClicked)
            }
        }
        tricksDisplay[sender.tag].saved = !tricksDisplay[sender.tag].saved
    }
    
    @objc private func buttonLearnClicked(_ sender: UIButton){
          if (tricksDisplay[sender.tag].learn == false){
              if let trickClicked = tricksDisplay[sender.tag].reference{
                  UserService().learnTrick(trick: trickClicked)
                tricksDisplay[sender.tag].learn = !tricksDisplay[sender.tag].learn
                print(tricksDisplay[sender.tag])
              }
          }
    }
}

// MARK: - EXTENSIONS

extension ListTricksViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tricksDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTricksCell",for: indexPath) as! ListTricksTableViewCell
        if tricksDisplay[indexPath.row].saved {
            cell.saveButton.setImage(UIImage(named: "icon-save_active"), for: .normal)
        }
        else {
            cell.saveButton.setImage(UIImage(named: "icon-save_regular"), for: .normal)
        }
        
        if tricksDisplay[indexPath.row].learn {
            cell.learnButton.setImage(UIImage(named: "icon-learn_active.png"), for: .normal)
        }
        
        switch indexPath.row % 2 {
        case 1:
            cell.contentView.backgroundColor = UIColor.CrewSade.darkGrey
            cell.trickName.textColor = UIColor.CrewSade.secondaryColorLight
            cell.trickLevel.textColor = UIColor.CrewSade.secondaryColorLight
            cell.trickContent.textColor = UIColor.CrewSade.secondaryColorLight
        default:
            cell.contentView.backgroundColor = UIColor.CrewSade.secondaryColor
            cell.trickName.textColor = UIColor.CrewSade.darkGrey
            cell.trickLevel.textColor = UIColor.CrewSade.darkGrey
            cell.trickContent.textColor = UIColor.CrewSade.darkGrey
        }
        cell.trickName.text = tricksDisplay[indexPath.row].name?.uppercased()
        cell.trickContent.text = tricksDisplay[indexPath.row].content
        cell.trickContent.sizeToFit()
        cell.trickLevel.text = tricksDisplay[indexPath.row].level?.uppercased()
        cell.saveButton.tag = indexPath.row
        cell.saveButton.addTarget(self, action: #selector(buttonSaveClicked(_:)), for: .touchUpInside)
        cell.learnButton.addTarget(self, action: #selector(buttonLearnClicked(_:)), for: .touchUpInside)
        return cell
    }
    
}

extension ListTricksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toARViewController", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
