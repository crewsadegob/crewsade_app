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
    var User: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        imageProfile.layer.masksToBounds = false
        imageProfile.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.frame.width/2 
        imageProfile.clipsToBounds = true
        
        self.navigationController?.navigationBar.topItem?.title = "PROFIL";

        
        // Do any additional setup after loading the view.
        if let user = user{
            UserService().getUserInformations(id: user.uid){ result in
                if let user = result{
                    self.User = user
                    self.usernameLabel.text = self.User?.username
                    let image = user.Image
                    self.imageProfile.sd_setImage(with: image, placeholderImage: UIImage(named:"placeholder.png"))
                    
                    
                }
            }
        }
    }
}
