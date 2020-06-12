//
//  ChallengeAcceptedViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 13/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ChallengeAcceptedViewController: UIViewController {
    
// MARK: - VARIABLES
    
    @IBOutlet weak var notPlaying: UIView!
    @IBOutlet weak var isPlaying: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var challengerName: UILabel!
    @IBOutlet weak var challengerImage: UIImageView!
    @IBOutlet weak var votingChallengerName: UILabel!
    
    let user = Auth.auth().currentUser
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        challengerImage.setRoundedImage()
        SessionService().setRound(view: self)
        
        SessionService().getChallengerInformations() { result in
            if let challenger = result{
                self.votingChallengerName.text = challenger.username
            }
        }

        if let user = user{
            SessionService().setViewPlayer(userId: user.uid){ result in

                if result == user.uid {
                    self.notPlaying.isHidden = true
                    self.isPlaying.isHidden = false
                    SessionService().manageScore(){result in
                       self.scoreLabel.setOutlineTextByScore(score: result)
                    }
                } else {
                    self.isPlaying.isHidden = true
                    self.notPlaying.isHidden = false
                    
                    SessionService().manageScore(){result in
                       self.scoreLabel.setOutlineTextByScore(score: result)
                    }
                }
            }
        }
        
        SessionService().getChallengerInformations(){result in
            if let challenger = result{
                self.challengerName.text = challenger.username
                self.challengerImage.sd_setImage(with: challenger.image, placeholderImage: UIImage(named:"placeholder-user.png"))
            }
        }
    }
    
// MARK: - ACTIONS
    
    @IBAction func validateButton(_ sender: UIButton) {
        SessionService().trickIsValidate()
    }
    
    @IBAction func denyButton(_ sender: UIButton) {
        SessionService().trickIsDeny()
    }
}
