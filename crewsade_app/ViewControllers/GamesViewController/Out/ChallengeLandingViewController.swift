//
//  ChallengeLandingViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 13/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ChallengeLandingViewController: UIViewController {
    
    let user = Auth.auth().currentUser

    @IBOutlet weak var imagePlayer1: UIImageView!
    @IBOutlet weak var imagePlayer2: UIImageView!
    
    @IBOutlet weak var usernamePlayer1: UILabel!
    @IBOutlet weak var usernamePlayer2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePlayer1.setRoundedImage()
        imagePlayer2.setRoundedImage()
        
        if let user = user{
            GamesService().getInformationsChallenge(userId: user.uid){ result in
                if let players = result{
                        self.usernamePlayer1.text = players[0].username
                        self.imagePlayer1.sd_setImage(with: players[0].Image, placeholderImage: UIImage(named:"placeholder.png"))
                    
                        self.usernamePlayer2.text = players[1].username
                    self.imagePlayer2.sd_setImage(with: players[1].Image, placeholderImage: UIImage(named:"placeholder.png"))
                }
            }
        }
    }

}
