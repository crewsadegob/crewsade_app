//
//  ListTricksTableViewCell.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 29/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ListTricksTableViewCell: UITableViewCell {

// MARK: - VARIABLES
    
    @IBOutlet weak var trickName: UILabel!
    @IBOutlet weak var trickLevel: UILabel!
    @IBOutlet weak var trickContent: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var learnButton: UIButton!
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
