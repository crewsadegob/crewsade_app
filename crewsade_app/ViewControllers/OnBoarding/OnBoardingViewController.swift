//
//  OnBoardingViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 07/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import SDWebImage

// TODO: S'inspirer du fonctionnement de l'héritage de ViewController avec la TabBar pour refacto le code des 4 ViewControllers
// de l'onboarding

class OnBoardingViewController: UIViewController {
    
// MARK: - VARIABLES
    
    @IBOutlet weak var OnBoardingButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var onboardingVisual: SDAnimatedImageView!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        
        self.hideNavigation()
        
        textLabel.setUppercased()
        textLabel.setLineSpacing(lineSpacing: 6.0)
        
        let gifUrl = "https://firebasestorage.googleapis.com/v0/b/crewsade-f8c30.appspot.com/o/gifs%2Fgif-onboarding_1.gif?alt=media&token=18782400-7ce2-4d2b-999f-7899bfee130e"
        
        onboardingVisual.sd_setImage(with: URL(string: gifUrl))
        
    }
    
// MARK: - ACTIONS
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
                let mainViewController = mainStoryboard.instantiateViewController(identifier: "OnBoarding2")
                self.show(mainViewController, sender: nil)
                
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
}
