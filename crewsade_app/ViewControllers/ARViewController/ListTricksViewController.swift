//
//  ListTricksViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 27/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class ListTricksViewController: UIViewController {

    var datas:[Trick] = [
        Trick(name: "Ollie", content: "A fundamental trick where the rider and board leap into the air without the use of the rider’s hands. A fundamental trick where the rider and board leap into the air.", level: "Difficult"),
        Trick(name: "Kickflip", content: "A fundamental trick where the rider and board leap into the air without the use of the rider’s hands. A fundamental trick where the rider and board leap into the air.", level: "Average"),
        Trick(name: "HeelFlip", content: "A fundamental trick where the rider and board leap into the air without the use of the rider’s hands. A fundamental trick where the rider and board leap into the air.", level: "Basic"),
        Trick(name: "Pop Shove It", content: "A fundamental trick where the rider and board leap into the air without the use of the rider’s hands. A fundamental trick where the rider and board leap into the air.", level: "Expert"),
    ]
    
    @IBOutlet weak var ListTricksTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ListTricksTable.delegate = self
        ListTricksTable.dataSource = self

        // Do any additional setup after loading the view.
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
        return datas.count
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
        cell.trickName.text = datas[indexPath.row].name.uppercased()
        cell.trickContent.text = datas[indexPath.row].content
        cell.trickLevel.text = datas[indexPath.row].level?.uppercased()
        
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


