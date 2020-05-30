//
//  WinChallengeViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class WinChallengeViewController: UIViewController {

    @IBOutlet weak var winnerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
             SessionService().displayWinner(){result in
                 self.winnerLabel.text = result
             }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserService().updateVictory()
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
