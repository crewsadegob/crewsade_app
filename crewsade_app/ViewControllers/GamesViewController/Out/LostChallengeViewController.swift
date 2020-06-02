//
//  LostChallengeViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class LostChallengeViewController: UIViewController {

    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        SessionService().manageScore(){result in
            self.scoreLabel.setOutlineTextByScore(score: result)
        }
        SessionService().displayWinner(){result in
            self.winnerLabel.text = result
        }
        
        
        let backImage = UIImage(named: "backItem")?.withRenderingMode(.alwaysOriginal)
          UINavigationBar.appearance().backIndicatorImage = backImage
          UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
          UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 0.0), for: .default)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        self.navigationItem.leftBarButtonItem?.action = #selector(back(sender:))

    }
    
   @objc func back(sender: UIBarButtonItem) {
         let mainStoryboard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)
                         let mainViewController = mainStoryboard.instantiateViewController(identifier: "Map")
                         self.show(mainViewController, sender: nil)
     }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
