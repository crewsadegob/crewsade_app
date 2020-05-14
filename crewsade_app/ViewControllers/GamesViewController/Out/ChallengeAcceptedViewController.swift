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

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            print(user)
           if let user = user{
            SessionService().setViewPlayer(userId: user.uid){ result in
                print(result)
                print(user)

                if result == user.uid{
                    self.notPlaying.isHidden = true
                }else{
                    self.isPlaying.isHidden = true
                }
            }// Do any additional setup after loading the view.
        }
    }
    
}
