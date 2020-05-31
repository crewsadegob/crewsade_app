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
        getCloseUsers()
        getRequestedSpot()
    }
    
    @IBAction func dismissSpotDetailView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func getRequestedSpot() {
        let spot = db.collection("spots").document(id)
        
        spot.getDocument { (spot, error) in
            if let spot = spot, spot.exists {
                if spot.get("image") != nil {
                    self.buildDetail(name: spot.get("name") as! String, coords: spot.get("coords") as! GeoPoint, image: spot.get("image") as! String)
                } else {
                    self.buildDetail(name: spot.get("name") as! String, coords: spot.get("coords") as! GeoPoint, image: "https://1.bp.blogspot.com/-kfpNhCO5Kxc/XXuFXWhvRoI/AAAAAAABC4g/8JvpD2-ar74RF7OCyZh88s8zfpbuDqwiQCLcBGAsYHQ/s1600/Skatepark%2BGennevilliers%2B3%2Bbis.jpg")
                }
                
                
            } else {
                
                print("Spot does not exist")
                
            }
        }
    }
    
    func getCloseUsers() {
        
        let _ = db.collection("spots").document(id).collection("closeUsers").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in snapshot!.documents {
                    //                    let id = document.documentID
                    let userReference = document.get("user") as! DocumentReference
                    
                    let user = userReference
                    
                    user.getDocument { (user, error) in
                        if let user = user, user.exists {
                            
                            let name = user.get("Username") as! String
                            let image = URL(string: user.get("Image") as! String)
                            let stats = user.get("Stats") as! [String: Int]
                            let user = User(username: name, Image: image, id: user.documentID,stats: stats)
                            self.users.append(user)
                            self.usersCarousel.reloadData()
                            
                        } else {
                            
                            print("User does not exist")
                            
                        }
                    }
                }
            }
        }
    }
    
    func buildDetail(name: String, coords: GeoPoint, image: String) {
        
        let user = locationManager.location!.coordinate
        let spotLocation = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
        
        let distance = round(spotLocation.distance(from: userLocation))
        
        spotName.text = name
        spotDistanceLabel.text = "\(distance)m"
        spotCloseUsersLabel.text = "2 riders sont à ce spot"
        spotPicture.sd_setImage(with: URL(string: image), completed: nil)
        
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
