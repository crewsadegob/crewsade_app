//
//  OnBoardingViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 07/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

// TODO: S'inspirer du fonctionnement de l'héritage de ViewController avec la TabBar pour refacto le code des 4 ViewControllers
// de l'onboarding

class OnBoardingViewController: UIViewController {
    
// MARK: - VARIABLES
    
    @IBOutlet weak var OnBoardingButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        
        self.hideNavigation()
        
        textLabel.setUppercased()
        textLabel.setLineSpacing(lineSpacing: 6.0)
        
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
