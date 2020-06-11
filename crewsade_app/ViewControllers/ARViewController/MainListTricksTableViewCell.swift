//
//  MainListTrickTableViewCell.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 05/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class MainListTrickTableViewCell: UITableViewCell {

// MARK: - VARIABLES
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var addTrick: UIButton!
    @IBOutlet weak var learnTrick: UIButton!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
