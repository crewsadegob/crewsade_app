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

    let user = Auth.auth().currentUser

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.setRoundedImage()
        self.hideNavigation()
        
        if let user = user{
              GamesService().getInformationsChallenge(userId: user.uid){ result in
                  if let players = result{
                          self.usernameLabel.text = players[1].username
                          self.imageView.sd_setImage(with: players[1].Image, placeholderImage: UIImage(named:"placeholder.png"))
                  }
              }
          }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func denyButtonClicked(_ sender: Any) {
        GamesService().denyChallenge(view: self)
        performSegueToReturnBack()
    }
    @IBAction func acceptButtonClicked(_ sender: Any) {
        GamesService().acceptChallenge(view: self)
        
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
