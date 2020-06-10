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
import FirebaseAuth
import FirebaseFirestore
import Geofirestore

class MapViewController: ViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var centerButton: UIButton!
    
    let user = Auth.auth().currentUser
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    
    var displayedSpotId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        GamesService().checkIsUserChallenged(view: self)
        customizeInterface()
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.isHidden = true
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    self.setupMap(center: CLLocationCoordinate2D(latitude: 48.859289, longitude: 2.340535), authorization: false)
                    centerButton.isEnabled = false
                case .authorizedAlways, .authorizedWhenInUse:
                    self.setupMap(center: CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude), authorization: true)
                    centerButton.isEnabled = true
                @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentSpotDetail" {
            
            if let dest = segue.destination as? SpotDetailViewController  {
                
                dest.id = displayedSpotId
                
            }
        }
    }
    
    override func addButtonTapped() {
        self.performSegue(withIdentifier: "presentSpotCreation", sender: self)
    }
    
    // ------------------- ACTIONS
    
    @IBAction func centerMapOnUser(_ sender: UIButton) {
        
        let user = self.locationManager.location!.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
        let camera = MGLMapCamera(lookingAtCenter: coordinate, altitude: 1500, pitch: 15, heading: 0)
        mapView.fly(to: camera, withDuration: 2, completionHandler: nil)
        
    }
    
    // ------------------- METHODS
    
    func customizeInterface() {
        centerButton.layer.cornerRadius = 25
        centerButton.backgroundColor = UIColor.CrewSade.mainColorLight
    }
    
    func setupMap(center: CLLocationCoordinate2D, authorization: Bool) {
            
        mapView.setCenter(center, zoomLevel: 15, animated: false)
        mapView.styleURL = URL(string: "mapbox://styles/loubatier/ck9s9jwa70afa1ipdyhuas2yk")
        mapView.isHidden = false
        self.getSpotsUpdates()
        
        if authorization {
            mapView.showsUserLocation = true
            self.updateLocation()
        }
    }
    
    func updateLocation() {
        UserService().updateUserLocation(location: locationManager.location!.coordinate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 300.0) { [weak self] in
            self?.updateLocation()
        }
    }
    
    func getSpotsUpdates() {
        
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
        }
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
        
        if !(annotation is MGLUserLocation) {
            if let id = annotation.title {
                
                self.displayedSpotId = id!
                
            }
            
            self.performSegue(withIdentifier: "presentSpotDetail", sender: self)
        }
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
            return CustomUserLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined, .restricted, .denied:
                self.setupMap(center: CLLocationCoordinate2D(latitude: 48.859289, longitude: 2.340535), authorization: false)
                centerButton.isEnabled = false
            case .authorizedAlways, .authorizedWhenInUse:
                self.setupMap(center: CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude), authorization: true)
                centerButton.isEnabled = true
            @unknown default:
            break
        }
    }
}
