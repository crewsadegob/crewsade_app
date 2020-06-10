//
//  OnBoarding2ViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 08/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class OnBoarding2ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        
        textLabel.setUppercased()
        textLabel.setLineSpacing(lineSpacing: 6.0)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
                let mainViewController = mainStoryboard.instantiateViewController(identifier: "OnBoarding3")
                self.show(mainViewController, sender: nil)
                
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
}
