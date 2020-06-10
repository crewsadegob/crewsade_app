//
//  UIView.swift
//  crewsade_app
//
//  Created by Lou Batier on 09/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundTopCorners() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
