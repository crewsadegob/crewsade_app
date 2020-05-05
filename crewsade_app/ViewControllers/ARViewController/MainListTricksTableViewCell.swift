//
//  MainListTrickTableViewCell.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 05/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class MainListTrickTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.CrewSade.secondaryColorLight
        self.layer.cornerRadius = 15.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
