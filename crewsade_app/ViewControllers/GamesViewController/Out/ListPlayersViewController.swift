//
//  ListPlayersViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 12/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
class ListPlayersViewController: UIViewController {
    
    var players = [User]()
    
    @IBOutlet weak var playersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playersTableView.delegate = self
        playersTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        GamesService().getPlayers(){result in
            if let playersGet = result{
                self.players = playersGet
                self.playersTableView.reloadData()
            }
            
        }
    }
    
    @objc private func buttonIsChallengedClicked(_ sender: UIButton){
        if let id = players[sender.tag].id{
            if let user = Auth.auth().currentUser{
                UserService().updateChallenge()
                GamesService().createSession(player1: id, player2: user.uid ,state: true, view: self)
                
            }
        }
    }
}

extension ListPlayersViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell",for: indexPath) as! ListPlayersTableViewCell
        
        
        switch indexPath.row % 2 {
        case 1:
            cell.contentView.backgroundColor = UIColor.CrewSade.darkGrey
            cell.namePlayer.textColor = UIColor.CrewSade.secondaryColorLight
        default:
            cell.contentView.backgroundColor = UIColor.CrewSade.secondaryColorLight
            cell.namePlayer.textColor = UIColor.CrewSade.darkGrey
            
        }
        
        cell.namePlayer.text = players[indexPath.row].username
        cell.imagePlayer.sd_setImage(with: players[indexPath.row].Image, placeholderImage: UIImage(named:"placeholder.png"))
        cell.buttonIsChallenged.tag = indexPath.row
        cell.buttonIsChallenged.addTarget(self, action: #selector(buttonIsChallengedClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
}

extension ListPlayersViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
