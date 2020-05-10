//
//  ProfileViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 08/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    var User: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UserService().getUserInformations(){ result in
            if let user = result{
                self.User = user
                self.usernameLabel.text = self.User?.username
                self.imageProfile.sd_setImage(with: self.User?.ProfilePicture, placeholderImage: UIImage(named:"placeholder.png"))
            }
        }
    }
    @IBAction func logOutButtonClicked(_ sender: Any) {
        UserService().logOut()
    }
}
