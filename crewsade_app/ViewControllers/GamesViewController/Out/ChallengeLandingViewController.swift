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
    
// MARK: - VARIABLES

    @IBOutlet weak var imagePlayer1: UIImageView!
    @IBOutlet weak var imagePlayer2: UIImageView!
    
    @IBOutlet weak var usernamePlayer1: UILabel!
    @IBOutlet weak var usernamePlayer2: UILabel!
    
    let user = Auth.auth().currentUser
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePlayer1.setRoundedImage()
        imagePlayer2.setRoundedImage()
        
        if let user = user{
            GamesService().getInformationsChallenge(userId: user.uid){ result in
                if let players = result{
                        self.usernamePlayer1.text = players[0].username
                        self.imagePlayer1.sd_setImage(with: players[0].image, placeholderImage: UIImage(named:"placeholder-user.png"))
                    
                        self.usernamePlayer2.text = players[1].username
                    self.imagePlayer2.sd_setImage(with: players[1].image, placeholderImage: UIImage(named:"placeholder-user.png"))
                }
            }
        }
    }
}
