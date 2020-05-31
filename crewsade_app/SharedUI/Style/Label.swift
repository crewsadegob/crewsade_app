//
//  Label.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 29/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit


extension UILabel{
    
    func test(x: Int){
        let strokeTextAttributes = [
               NSAttributedString.Key.strokeColor : UIColor.CrewSade.secondaryColorLight,
               NSAttributedString.Key.foregroundColor : UIColor.clear,
               NSAttributedString.Key.strokeWidth : -3.0,
               NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 160)]
               as [NSAttributedString.Key : Any]
           //Making outline here
           self.attributedText = NSMutableAttributedString(string: "h", attributes: strokeTextAttributes)
           
        let range = NSRange(location:0,length: 3 - x)

        let attributedString = self.text as! NSMutableAttributedString
          // here you change the character to red color
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.CrewSade.secondaryColorLight, range: range)
          self.attributedText = attributedString
        
        print(self.attributedText)
        
    }
}
