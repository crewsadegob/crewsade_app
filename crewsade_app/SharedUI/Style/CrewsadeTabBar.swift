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
    @IBOutlet weak var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.CrewSade.darkGrey
        roundTopCorners()
    }
    
    @IBAction func tabBarButtonClicked(_ sender: UIButton) {
        tapHandler?.tapped(index: sender.tag)
    }
}

protocol TapHandler: class {
    func tapped(index: Int)
}
