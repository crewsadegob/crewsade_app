//
//  CarouselTricksCollectionViewCell.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 06/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class CarouselTricksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameTrick: UILabel!
    @IBOutlet weak var nameLevel: UILabel!
    
    var trick: Trick? {
       didSet {
          self.updateUI()
       }
    }
       
    private func updateUI() {
       if let trick = trick {
          nameTrick.text = trick.name
          nameLevel.text = trick.level
       } else {
          nameTrick.text = nil
          nameLevel.text = nil
       }
    }
       
    override func layoutSubviews() {
       super.layoutSubviews()
       
       self.layer.cornerRadius = 3.0
       layer.shadowRadius = 10
       layer.shadowOpacity = 0.2
       layer.shadowOffset = CGSize(width: 5, height: 10)
       
       self.clipsToBounds = false
    }

}
