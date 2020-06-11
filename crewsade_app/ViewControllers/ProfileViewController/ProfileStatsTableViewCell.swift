//
//  ProfileStatsTableViewCell.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class ProfileStatsTableViewCell: UITableViewCell {

// MARK: - VARIABLES
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
