//
//  ChallengeRoundViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 02/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ChallengeRoundViewController: UIViewController {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var usernamePlayer1: UILabel!
    @IBOutlet weak var scorePlayer1: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var usernamePlayer2: UILabel!
    @IBOutlet weak var scorePlayer2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigation()
        
        SessionService().getPlayersDataGames(){ result in
            self.usernamePlayer1.text = result.player1.username
            self.scorePlayer1.setOutlineTextByScore(score: result.player1.score)
            
            self.roundLabel.text = "ROUND \(Int(result.roundStep))"
            
            self.usernamePlayer2.text = result.player2.username
            self.scorePlayer2.setOutlineTextByScore(score: result.player2.score)
            
        }
    
        if let user = user{
            SessionService().checkIsWin(){ result in
                
                switch result{
                case user.uid :
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                    let mainViewController = mainStoryboard.instantiateViewController(identifier: "win")
                    self.show(mainViewController, sender: nil)
                    break
                    
                case "don't finish" :
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                        let mainViewController = mainStoryboard.instantiateViewController(identifier: "gameStart")
                        self!.show(mainViewController, sender: nil)
                    }
                    
                default :
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
                    let mainViewController = mainStoryboard.instantiateViewController(identifier: "lose")
                    self.show(mainViewController, sender: nil)
                    break
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SessionService().updateRound()
    }
}
