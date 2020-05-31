//
//  ProfileViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 08/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
class ProfileViewController: UIViewController {
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var statsTable: UITableView!
    var User: User?
    var stats =  [String: Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsTable.delegate = self
        statsTable.dataSource = self
        
        imageProfile.setRoundedImage()
        
        self.navigationController?.navigationBar.topItem?.title = "PROFIL";
        usernameLabel.test(x: 2)
        
        // Do any additional setup after loading the view.
        if let user = user{
            UserService().getUserInformations(id: user.uid){ result in
                if let user = result{
                    self.User = user
                    self.usernameLabel.text = self.User?.username
                    let image = user.Image
                    self.imageProfile.sd_setImage(with: image, placeholderImage: UIImage(named:"placeholder.png"))
                    self.stats = user.stats
                    self.statsTable.reloadData()
                    
                }
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell",for: indexPath) as! ProfileStatsTableViewCell
        switch indexPath.row {
        case 0:
            cell.nameValueLabel.text =  "VICTOIRES"
            if let victory = stats["Victory"] {
                cell.valueLabel.text = "\(victory)"
            }
            break
        case 1:
            cell.nameValueLabel.text =  "TRICKS ACQUIS"
            if let tricks = stats["Tricks"] {
                cell.valueLabel.text = "\(tricks)"
            }
            break
        case 2:
            cell.nameValueLabel.text =  "LANCEMENTS DE DÉFIS"
            if let challenge = stats["Challenge"] {
                cell.valueLabel.text = "\(challenge)"
            }
            break
        case 3:
            cell.nameValueLabel.text =  "SPOTS AJOUTÉS"
            
            if let spots = stats["Spots"] {
                cell.valueLabel.text = "\(spots)"
            }
            break
            
        default:
            return cell
        }
        
        switch indexPath.row % 2 {
        case 1:
            cell.contentView.backgroundColor = UIColor.CrewSade.mainColor
            
        default:
            cell.contentView.backgroundColor = UIColor.CrewSade.darkGrey
            
        }
        
        
        
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
