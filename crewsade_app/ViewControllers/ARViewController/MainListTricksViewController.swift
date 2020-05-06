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
        
        
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "background.png")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
        
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
    @objc private func buttonSaveClicked(_ sender: UIButton){
        if let trickClicked = tricks[sender.tag].reference{
            UserService().deleteTrick(trick: trickClicked)
            mainListTricksTable.reloadData()
        }
    }
    
}

extension MainListTricksViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tricks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainListTricksCell",for: indexPath) as! MainListTrickTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let roundedView : UIView = UIView(frame: CGRect(x: 0, y: 10, width: cell.frame.size.width, height: 100))
        roundedView.layer.backgroundColor = UIColor.CrewSade.secondaryColorLight.cgColor
        roundedView.layer.masksToBounds = false
        roundedView.layer.cornerRadius = 15.0
    
        
        cell.contentView.addSubview(roundedView)
        cell.contentView.sendSubviewToBack(roundedView)
        
        cell.nameLabel?.text = tricks[indexPath.row].name?.uppercased()
        cell.saveButton.tag = indexPath.row
        cell.saveButton.addTarget(self, action: #selector(self.buttonSaveClicked(_:)), for: .touchUpInside)

        return cell
    }
    
}

extension MainListTricksViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

   
}
