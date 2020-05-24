//
//  Trick.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 29/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Trick {
    
    var name:String?
    var content:String?
    var level:String?
    var reference:DocumentReference?
    var scene: String?
    var saved = false
    
}
