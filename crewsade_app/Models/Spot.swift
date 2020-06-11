//
//  Spot.swift
//  crewsade_app
//
//  Created by Lou Batier on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Spot {
    
    var id: String
    var name: String
    var location: CLLocationCoordinate2D
    var game: Bool
    var reference: DocumentReference
    
}
