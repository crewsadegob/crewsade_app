//
//  CustomUserLocationAnnotation.swift
//  crewsade_app
//
//  Created by Lou Batier on 09/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class CustomUserLocation: MGLUserLocationAnnotationView {
    let big: CGFloat = 32
    let small: CGFloat = 12
    var outer: CALayer!
    var inner: CALayer!
    
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: big, height: big)
            return setNeedsLayout()
        }
        
        if CLLocationCoordinate2DIsValid(userLocation!.coordinate) {
            setupLayers()
        }
    }
     
    private func setupLayers() {
        
        if outer == nil {
            outer = CALayer()
            outer.bounds = CGRect(x: 0, y: 0, width: big, height: big)
            outer.cornerRadius = big / 2
            outer.backgroundColor = UIColor.CrewSade.mainColorTransparent.cgColor
            outer.borderWidth = 1
            outer.borderColor = UIColor.CrewSade.mainColorLight.cgColor
            layer.addSublayer(outer)
        }
        
        if inner == nil {
            inner = CALayer()
            inner.bounds = CGRect(x: 0, y: 0, width: small, height: small)
            inner.cornerRadius = small / 2
            inner.backgroundColor = UIColor.CrewSade.mainColorLight.cgColor
            layer.addSublayer(inner)
        }
        
    }
}
