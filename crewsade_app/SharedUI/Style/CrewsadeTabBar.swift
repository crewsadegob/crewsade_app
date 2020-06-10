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
    
    @IBOutlet weak var contentView: CrewsadeTabBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        backgroundColor = .red
    }
    
}
