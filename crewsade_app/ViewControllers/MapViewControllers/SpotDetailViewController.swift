//
//  SpotDetailViewController.swift
//  crewsade_app
//
//  Created by Lou Batier on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import CoreLocation
import Geofirestore
import FirebaseFirestore
import SDWebImage

class SpotDetailViewController: UIViewController {

    @IBOutlet weak var spotDetailContainer: UIView!
    @IBOutlet weak var spotPicture: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var spotDistanceLabel: UILabel!
    @IBOutlet weak var spotCloseUsersLabel: UILabel!
    
    @IBOutlet weak var usersCarousel: UICollectionView!
    
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    let geofire = GeoFirestore(collectionRef: Firestore.firestore().collection("geofire"))
    
    var id: String = ""
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersCarousel.dataSource = self
        usersCarousel.delegate = self
        
        setupLocationManager()
        getSurroundings()
        getRequestedSpot()
        
    }
    
    // ------------------- ACTIONS
    
    @IBAction func dismissSpotDetailView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // ------------------- METHODS
    
    func getRequestedSpot() {
        let spot = db.collection("spots").document(id)
        
        spot.getDocument { (spot, error) in
            if let spot = spot, spot.exists {

                self.buildDetailView(name: spot.get("name") as! String, location: spot.get("l") as! GeoPoint, image: spot.get("image") as! String)

            } else {
                
                print("Le spot n'existe pas")
                
            }
        }
    }
    
    func getSurroundings() {
        
        let spotsRef = db.collection("spots")
        let spotsCol = GeoFirestore(collectionRef: spotsRef)
        
        let usersRef = db.collection("users")
        let usersCol = GeoFirestore(collectionRef: usersRef)
        
        spotsCol.getLocation(forDocumentWithID: id) { (location: GeoPoint?, error) in
            if let error = error {
                print("Une erreur est survenue : \(error)")
            } else if let location = location {
                
                let center = GeoPoint(latitude: location.latitude, longitude: location.longitude)
                let rangeQuery = usersCol.query(withCenter: center, radius: 1)
                print("Centre de la zone du spot : \(center)")
                
                let _ = rangeQuery.observe(.documentEntered, with: { (key, location) in
                    if let userId = key {
                        print("Le document d'id : '\(String(describing: userId))' est entré dans la zone et est aux coordonnées : '\(String(describing: location))'")
                        
                        let user = usersRef.document(userId)
                        user.getDocument { (user, error) in
                            if let user = user, user.exists {
                                let name = user.get("Username") as! String
                                let image = URL(string: user.get("Image") as! String)

                                let user = User(username: name, ProfilePicture: image)
                                self.users.append(user)
                                
                                self.spotCloseUsersLabel.text = "\(self.users.count) riders sont à ce spot"
                                self.usersCarousel.reloadData()

                            } else {
                                
                                print("User does not exist")
                                
                            }
                        }
                    }
                    
                })
                
                let _ = rangeQuery.observe(.documentExited, with: { (key, location) in
                    if let userId = key {
                        print("Le document d'id : '\(String(describing: key))' est sorti de la zone et est aux coordonnées : '\(String(describing: location))'")
                        
                        let user = usersRef.document(userId)
                        user.getDocument { (user, error) in
                            if let user = user, user.exists {
                                let name = user.get("Username") as! String
                                let image = URL(string: user.get("Image") as! String)

                                let user = User(username: name, ProfilePicture: image)
                                
                                if let index = self.users.firstIndex(of: user) {
                                    self.users.remove(at: index)
                                }
                                
                                self.spotCloseUsersLabel.text = "\(self.users.count) riders sont à ce spot"
                                self.usersCarousel.reloadData()

                            } else {
                                
                                print("User does not exist")
                                
                            }
                        }
                    }
                    
                })
                
            } else {
                print("Ce document ne possède pas de localisation")
            }
        }
    }
    
    func buildDetailView(name: String, location: GeoPoint, image: String) {
        
        let user = locationManager.location!.coordinate
        let spotLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
        
        let distance = round(spotLocation.distance(from: userLocation))
        
        spotName.text = name
        spotDistanceLabel.text = "\(distance)m"
        spotCloseUsersLabel.text = "\(users.count) riders sont à ce spot"
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

// ------------------- EXTENSIONS

extension SpotDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ : CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
    }
}

extension SpotDetailViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! CarouselUsersCollectionViewCell
        
        cell.user = users[indexPath.item]
        cell.contentView.backgroundColor = UIColor.CrewSade.secondaryColor
        cell.contentView.layer.cornerRadius = 15.0
        return cell
    }
}

extension SpotDetailViewController: UIScrollViewDelegate, UICollectionViewDelegate
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.usersCarousel.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
