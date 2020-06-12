//
//  LostChallengeViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class LostChallengeViewController: UIViewController {

// MARK: - VARIABLES

    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SessionService().manageScore(){result in
            self.scoreLabel.setOutlineTextByScore(score: result)
        }
        SessionService().displayWinner(){result in
            self.winnerLabel.text = result
        }
        
       DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
       }
                
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SessionService().endSession()
    }

}
