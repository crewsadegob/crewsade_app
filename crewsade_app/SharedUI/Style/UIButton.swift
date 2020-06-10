//
//  Button.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 05/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

extension UIButton {
    
    func addTextSpacing(_ letterSpacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
}
