//
//  MapViewController.swift
//  crewsade_app
//
//  Created by Lou Batier on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import FirebaseFirestore
import Geofirestore

class MapViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var mapView: MGLMapView!
    
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    
    var displayedSpotId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        getDatabaseUpdates()
        GamesService().checkIsUserChallenged(view: self)
        
        view.bringSubviewToFront(addButton)
        view.bringSubviewToFront(centerButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentSpotDetail" {
            
            if let dest = segue.destination as? SpotDetailViewController  {
                
                dest.id = displayedSpotId
                
            }
        }
    }
    
    // ------------------- ACTIONS
    
    @IBAction func centerMapOnUser(_ sender: UIButton) {
        
        let user = self.locationManager.location!.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
        let camera = MGLMapCamera(lookingAtCenter: coordinate, altitude: 1500, pitch: 15, heading: 0)
        mapView.fly(to: camera, withDuration: 2, completionHandler: nil)
        
    }
    
    // ------------------- METHODS
    
    func getDatabaseUpdates() {
        
       db.collection("spots").addSnapshotListener { snapshot, err in
            if let err = err {
                print("Error retreiving collection: \(err)")
            } else {
                self.getSpotsInDatabase()
            }
        }
        
    }
    
    func getSpotsInDatabase() {
        
        let _ = db.collection("spots").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let id = document.documentID
                    let name = document.get("name") as! String
                    let game = document.get("game") as! Bool
                    let location = document.get("l") as! GeoPoint

                    let spot = Spot(id: id, name: name, location: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), game: game, reference: document.reference)
                    
                    self.updateMapAnnotations(spot: spot)
                }
            }
        }
    }
    
    func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            setupMap()
        }
    }
    
    func setupMap() {

//        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserHeadingIndicator = true

        mapView.delegate = self
        mapView.showsUserLocation = true

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude), zoomLevel: 15, animated: false)
        mapView.styleURL = URL(string: "mapbox://styles/loubatier/ck9s9jwa70afa1ipdyhuas2yk")
    }
    
    func updateMapAnnotations(spot: Spot) {
        
        let point = MGLPointAnnotation()
        point.coordinate = spot.location
        point.title = "\(spot.id)"
        point.subtitle = "\(spot.game)"
        mapView.addAnnotation(point)
        
    }

}

// ------------------- EXTENSIONS

extension MapViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, altitude: 1500, pitch: 15, heading: 0)
        mapView.fly(to: camera, withDuration: 2, completionHandler: nil)
        
        if let id = annotation.title {
            
            self.displayedSpotId = id!
            
        }
        
        self.performSegue(withIdentifier: "presentSpotDetail", sender: self)
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let game = annotation.subtitle
    
        if let id = annotation.title {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: id!)
            
            if game == "true" {
                annotationImage = MGLAnnotationImage(image: UIImage(named: "pin_active")!, reuseIdentifier: id!)
            } else {
                annotationImage = MGLAnnotationImage(image: UIImage(named: "pin_regular")!, reuseIdentifier: id!)
            }
            
            return annotationImage
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {

        if annotation is MGLUserLocation {
            return CustomUserLocationAnnotationView()
        }
        
        return nil
        
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ : CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
    }
}

// CUSTOM USER VIEW

class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    let size: CGFloat = 48
    var dot: CALayer!
    var arrow: CAShapeLayer!
     
    // -update is a method inherited from MGLUserLocationAnnotationView. It updates the appearance of the user location annotation when needed. This can be called many times a second, so be careful to keep it lightweight.
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: size, height: size)
            return setNeedsLayout()
        }
         
        // Check whether we have the user’s location yet.
        if CLLocationCoordinate2DIsValid(userLocation!.coordinate) {
            setupLayers()
            updateHeading()
        }
    }
     
    private func updateHeading() {
        // Show the heading arrow, if the heading of the user is available.
        if let heading = userLocation!.heading?.trueHeading {
            arrow.isHidden = false
         
            // Get the difference between the map’s current direction and the user’s heading, then convert it from degrees to radians.
            let rotation: CGFloat = -MGLRadiansFromDegrees(mapView!.direction - heading)
         
            // If the difference would be perceptible, rotate the arrow.
            if abs(rotation) > 0.01 {
                // Disable implicit animations of this rotation, which reduces lag between changes.
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                arrow.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))
                CATransaction.commit()
            }
        } else {
            arrow.isHidden = true
        }
    }
     
    private func setupLayers() {
        // This dot forms the base of the annotation.
        if dot == nil {
            dot = CALayer()
            dot.bounds = CGRect(x: 0, y: 0, width: size, height: size)
             
            // Use CALayer’s corner radius to turn this layer into a circle.
            dot.cornerRadius = size / 2
            dot.backgroundColor = super.tintColor.cgColor
            dot.borderWidth = 4
            dot.borderColor = UIColor.black.cgColor
            layer.addSublayer(dot)
            }
             
            // This arrow overlays the dot and is rotated with the user’s heading.
            if arrow == nil {
            arrow = CAShapeLayer()
            arrow.path = arrowPath()
            arrow.frame = CGRect(x: 0, y: 0, width: size / 2, height: size / 2)
            arrow.position = CGPoint(x: dot.frame.midX, y: dot.frame.midY)
            arrow.fillColor = dot.borderColor
            layer.addSublayer(arrow)
        }
    }
     
    // Calculate the vector path for an arrow, for use in a shape layer.
    private func arrowPath() -> CGPath {
        let max: CGFloat = size / 2
        let pad: CGFloat = 3
         
        let top =    CGPoint(x: max * 0.5, y: 0)
        let left =   CGPoint(x: 0 + pad,   y: max - pad)
        let right =  CGPoint(x: max - pad, y: max - pad)
        let center = CGPoint(x: max * 0.5, y: max * 0.6)
         
        let bezierPath = UIBezierPath()
        bezierPath.move(to: top)
        bezierPath.addLine(to: left)
        bezierPath.addLine(to: center)
        bezierPath.addLine(to: right)
        bezierPath.addLine(to: top)
        bezierPath.close()
         
        return bezierPath.cgPath
    }
}
