//
//  User.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 04/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation

struct User: Equatable {
    
    let username: String?
    let image: URL?
    let id: String?
    let stats: [String: Int]
    var score: Int = 0
    
}
