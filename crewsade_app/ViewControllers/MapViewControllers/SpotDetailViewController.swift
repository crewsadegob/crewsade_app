//
//  SpotDetailViewController.swift
//  crewsade_app
//
//  Created by Lou Batier on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseFirestore
import SDWebImage

class SpotDetailViewController: UIViewController {

    @IBOutlet weak var spotDetailContainer: UIView!
    @IBOutlet weak var spotPicture: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var spotDistanceLabel: UILabel!
    @IBOutlet weak var spotCloseUsersLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var db = Firestore.firestore()
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        getRequestedSpot()
        
    }
    
    @IBAction func dismissSpotDetailView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func getRequestedSpot() {
        let spot = db.collection("spots").document(id)
        
        spot.getDocument { (spot, error) in
            if let spot = spot, spot.exists {

                self.buildDetail(name: spot.get("name") as! String, coords: spot.get("coords") as! GeoPoint, image: spot.get("image") as! String)

            } else {
                
                print("Spot does not exist")
                
            }
        }
    }
    
    func buildDetail(name: String, coords: GeoPoint, image: String) {
        
        let user = locationManager.location!.coordinate
        let spotLocation = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
        
        let distance = round(spotLocation.distance(from: userLocation))
        
        spotName.text = name
        spotDistanceLabel.text = String(distance)
        spotPicture.sd_setImage(with: URL(string: image))
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
    
}

extension SpotDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ : CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
    }
}
