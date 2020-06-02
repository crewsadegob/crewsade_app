//
//  ImageView.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 31/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

extension UIImageView{
    func setRoundedImage(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
}
