//
//  Colors.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 23/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  struct CrewSade {
    static var mainColor: UIColor  { return UIColor(red: 255/255, green: 82/255, blue: 45/255, alpha: 1.0) }
    static var mainColorLight: UIColor  { return UIColor(red: 255/255, green: 110/255, blue: 78/255, alpha: 1.0) }
    static var mainColorTransparent: UIColor  { return UIColor(red: 255/255, green: 82/255, blue: 45/255, alpha: 0.3) }
    
    static var secondaryColor: UIColor { return UIColor(red: 241/255, green: 234/255, blue: 216/255, alpha: 1.0) }
    static var secondaryColorLight: UIColor { return UIColor(red: 255/255, green: 252/255, blue: 243/255, alpha: 1.0) }
    
    static var darkGrey: UIColor { return UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1.0) }
  }
}

