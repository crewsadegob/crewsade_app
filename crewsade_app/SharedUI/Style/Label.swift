//
//  Label.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 29/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit


extension UILabel {
    
    func setOutlineTextByScore(score: Int) {
        
        var coloredText: String = ""
        
        let basicAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.CrewSade.secondaryColorLight,
               NSAttributedString.Key.foregroundColor : UIColor.clear,
               NSAttributedString.Key.strokeWidth : -3.0]
               as [NSAttributedString.Key : Any]
        
        let newAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.CrewSade.secondaryColorLight]
                     as [NSAttributedString.Key : Any]
        
        
        switch score {
        case 2:
            coloredText = "O"
            break
        case 1:
            coloredText = "OU"
            break
        case 0:
            coloredText = "OUT"
            break
        default:
            coloredText = ""
        }
        
        
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.setAttributes(basicAttributes, range: NSRange(location:0, length: self.text!.count))
        let range = (text! as NSString).range(of: coloredText)
        attributedString.setAttributes(newAttributes,
                                       range: range)
        self.attributedText = attributedString
    }
}
