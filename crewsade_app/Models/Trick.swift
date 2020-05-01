//
//  Trick.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 29/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Trick {
    
    var name:String
    var content:String
    var level:String?
    var reference:DocumentReference
    
    init(name:String, content:String, level:String?, reference: DocumentReference) {
        self.name = name
        self.content = content
        self.level = level
        self.reference = reference
    }
}
