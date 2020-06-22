//
//  OnBoarding4ViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 08/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import SDWebImage

class OnBoarding4ViewController: UIViewController {
    
// MARK: - VARIABLES
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var onboardingVisual: SDAnimatedImageView!
    
    // MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        
        textLabel.setUppercased()
        textLabel.setLineSpacing(lineSpacing: 6.0)
        
        let gifUrl = "https://firebasestorage.googleapis.com/v0/b/crewsade-f8c30.appspot.com/o/gifs%2FShow-off-min.gif?alt=media&token=8063867d-96d2-4e6b-8eeb-87517332fa2f"
        
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
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
                self.show(mainViewController, sender: nil)
                
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
}
