//
//  CrewsadeTabBar.swift
//  crewsade_app
//
//  Created by Lou Batier on 10/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import UIKit


class CrewsadeTabBar: UIView {
    weak var tapHandler: TapHandler?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        addButton.backgroundColor = UIColor.CrewSade.mainColorLight
        addButton.layer.cornerRadius = addButton.frame.width / 2
        
        contentView.backgroundColor = UIColor.CrewSade.darkGrey
        contentView.roundTopCorners()
    }
    
    func hideAddButton() {
        addButton.isHidden = true
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        tapHandler?.addButtonTapped()
    }
    
    @IBAction func tabBarButtonClicked(_ sender: UIButton) {
        tapHandler?.tabBarButtonTapped(index: sender.tag)
    }
}

protocol TapHandler: class {
    func tabBarButtonTapped(index: Int)
    func addButtonTapped()
}
