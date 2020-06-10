//
//  CarouselUsersTableViewCell.swift
//  crewsade_app
//
//  Created by Lou Batier on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import SDWebImage

class CarouselUsersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var duelButton: UIButton!
    
    var user: User? {
        didSet {
            customizeInterface()
            self.updateCell()
        }
    }
    
    func customizeInterface() {
        userPicture.layer.cornerRadius = userPicture.frame.size.width / 2
        duelButton.setTitle(duelButton.titleLabel?.text?.uppercased(), for: .normal)
        duelButton.backgroundColor = UIColor.CrewSade.darkGrey
        duelButton.layer.cornerRadius = 5
        duelButton.contentEdgeInsets = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15)
        duelButton.sizeToFit()
        
    }
    
    private func updateCell() {
        if let user = user {
            
            userName.text = user.username?.uppercased()
            userPicture.sd_setImage(with: user.image)
            
        } else {
            
            userName.text = nil
            
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
