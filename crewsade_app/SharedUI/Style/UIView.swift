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
}
