//
//  ChallengeAcceptedViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 13/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import Firebase
class ChallengeAcceptedViewController: UIViewController {
    let user = Auth.auth().currentUser

    @IBOutlet weak var notPlaying: UIView!
    @IBOutlet weak var isPlaying: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
          if let user = user{
            SessionService().setViewPlayer(userId: user.uid){ result in
                if result == user.uid{
                    self.isPlaying.isHidden = true
                    print("player")
                }else{
                    self.notPlaying.isHidden = true
                    print("Not player")

                }
            }// Do any additional setup after loading the view.
        }

    }

    @IBAction func validateButton(_ sender: UIButton) {
        SessionService().trickIsValidate(){ success in
            if success{
                self.notPlaying.isHidden = true
                self.isPlaying.isHidden = false
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
