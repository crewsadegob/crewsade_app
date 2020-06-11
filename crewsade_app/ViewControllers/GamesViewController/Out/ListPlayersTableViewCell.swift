//
//  ListPlayersTableViewCell.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 12/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class ListPlayersTableViewCell: UITableViewCell {

// MARK: - VARIABLES
    
    @IBOutlet weak var imagePlayer: UIImageView!
    @IBOutlet weak var namePlayer: UILabel!
    @IBOutlet weak var buttonIsChallenged: UIButton!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePlayer.setRoundedImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
