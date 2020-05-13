//
//  ListPlayersTableViewCell.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 12/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class ListPlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePlayer: UIImageView!
    @IBOutlet weak var namePlayer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
