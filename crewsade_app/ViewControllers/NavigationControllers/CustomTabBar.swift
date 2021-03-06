//
//  CustomTabBar.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 10/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {

    let roundedView = UIView(frame: .zero)
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 30
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let position = CGPoint(x: 0, y: 0)
        let size = CGSize(width: self.frame.width, height: self.frame.height)
        roundedView.frame = CGRect(origin: position, size: size)
    }
}
