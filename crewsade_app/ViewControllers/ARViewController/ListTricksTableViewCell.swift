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

    @IBOutlet weak var trickName: UILabel!
    @IBOutlet weak var trickLevel: UILabel!
    @IBOutlet weak var trickContent: UILabel!
    @IBOutlet weak var saveButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
