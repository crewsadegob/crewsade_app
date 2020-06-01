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
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var notPlaying: UIView!
    @IBOutlet weak var isPlaying: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var challengerName: UILabel!
    @IBOutlet weak var challengerImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        challengerImage.setRoundedImage()
        
        if let user = user{
            SessionService().setViewPlayer(userId: user.uid){ result in
                if result == user.uid{
                    self.notPlaying.isHidden = true
                    self.isPlaying.isHidden = false
                    SessionService().manageScore(){result in
                               self.scoreLabel.setOutlineTextByScore(score: result)
                           }
                    print("player")
                }else{
                    self.isPlaying.isHidden = true
                    self.notPlaying.isHidden = false
                    SessionService().manageScore(){result in
                               self.scoreLabel.setOutlineTextByScore(score: result)
                    }
                    print("Not player")
                    
                }
            }
            SessionService().checkIsWin(){ result in
                if result == user.uid{
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                    let mainViewController = mainStoryboard.instantiateViewController(identifier: "win")
                    self.show(mainViewController, sender: nil)
                }
                else{
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                                 let mainViewController = mainStoryboard.instantiateViewController(identifier: "lose")
                                 self.show(mainViewController, sender: nil)
                }
                
            }
        }
        
        SessionService().getChallengerInformations(){result in
            if let challenger = result{
                print("challenger: \(challenger)")
                self.challengerName.text = challenger.username
                self.challengerImage.sd_setImage(with: challenger.Image, placeholderImage: UIImage(named:"placeholder.png"))
            }
        }
        
       
        
        
    }
    
    @IBAction func validateButton(_ sender: UIButton) {
        SessionService().trickIsValidate(){ success in
            if success{
                //                self.notPlaying.isHidden = true
                //                self.isPlaying.isHidden = false
            }
        }
    }
    
    @IBAction func denyButton(_ sender: UIButton) {
        SessionService().trickIsDeny(){ success in
            if success{
                print("Perdu")
            }
        }
    }
}
