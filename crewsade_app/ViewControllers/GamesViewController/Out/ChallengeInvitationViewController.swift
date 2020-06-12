//
//  ChallengeInvitationViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 29/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ChallengeInvitationViewController: UIViewController {

// MARK: - VARIABLES

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let user = Auth.auth().currentUser
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigation()
        
        imageView.setRoundedImage()
        
        if let user = user {
           GamesService().getInformationsChallenge(userId: user.uid){ result in
              if let players = result{
                      self.usernameLabel.text = players[1].username
                      self.imageView.sd_setImage(with: players[1].image, placeholderImage: UIImage(named:"placeholder-user.png"))
              }
           }
        }
    }
    
// MARK: - ACTIONS
    
    @IBAction func denyButtonClicked(_ sender: Any) {
        GamesService().denyChallenge(view: self)
        performSegueToReturnBack()
    }
    
    @IBAction func acceptButtonClicked(_ sender: Any) {
        GamesService().acceptChallenge(view: self)
        
    }
}
