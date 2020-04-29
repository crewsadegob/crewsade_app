//
//  Trick.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 29/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation

class Trick {
    
    var name:String
    var content:String
    var level:String?
    
    init(name:String, content:String, level:String?) {
        self.name = name
        self.content = content
        self.level = level
    }
}
