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
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class SpotDetailViewController: UIViewController {
    
// MARK: - VARIABLES
    
    @IBOutlet weak var spotDetailContainer: UIView!
    @IBOutlet weak var spotPicture: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var spotDistanceLabel: UILabel!
    @IBOutlet weak var spotCloseUsersLabel: UILabel!
    
    @IBOutlet weak var usersCarousel: UICollectionView!
    
    let user = Auth.auth().currentUser
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    let geofire = GeoFirestore(collectionRef: Firestore.firestore().collection("geofire"))
    
    var id: String = ""
    var users = [User]()
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersCarousel.dataSource = self
        usersCarousel.delegate = self
        
        setupLocationManager()
        getSurroundings()
        getRequestedSpot()
        customizeInterface()
        
    }
    
// MARK: - ACTIONS
    
    @IBAction func dismissSpotDetailView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
// MARK: - METHODS
    
    func customizeInterface() {
        spotDetailContainer.layer.cornerRadius = 15
        spotPicture.roundTopCorners()
        spotPicture.layer.masksToBounds = true
        
        spotDistanceLabel.textColor = UIColor.white
        spotDistanceLabel.backgroundColor = UIColor.CrewSade.darkGrey
        spotDistanceLabel.layer.cornerRadius = 9
        spotDistanceLabel.layer.masksToBounds = true
        spotCloseUsersLabel.textColor = UIColor.white
        spotCloseUsersLabel.backgroundColor = UIColor.CrewSade.mainColorLight
        spotCloseUsersLabel.layer.cornerRadius = 9
        spotCloseUsersLabel.layer.masksToBounds = true
        
        spotCloseUsersLabel.sizeToFit()
    }
    
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
                    if let key = key {
                        print("Le document d'id : '\(String(describing: key))' est entré dans la zone et est aux coordonnées : '\(String(describing: location))'")
                        
                        if self.user!.uid != key {
                            let user = usersRef.document(key)
                            user.getDocument { (user, error) in
                                if let user = user, user.exists {
                                    
                                    let name = user.get("Username") as! String
                                    let image = URL(string: user.get("Image") as! String)
                                    let stats = user.get("Stats") as! [String: Int]
                                    
                                    let user = User(username: name, image: image, id: key, stats: stats)
                                    self.users.append(user)
                                    
                                    if self.users.count == 0  {
                                        self.spotCloseUsersLabel.text = "Aucun rider à ce spot"
                                    } else if self.users.count == 1{
                                        self.spotCloseUsersLabel.text = "\(self.users.count) rider est à ce spot"
                                    } else {
                                        self.spotCloseUsersLabel.text = "\(self.users.count) riders sont à ce spot"
                                    }
                                    
                                    self.usersCarousel.reloadData()

                                } else {
                                    
                                    print("User does not exist")
                                    
                                }
                            }
                        }
                    }
                })
                
                let _ = rangeQuery.observe(.documentExited, with: { (key, location) in
                    if let key = key {
                        print("Le document d'id : '\(String(describing: key))' est sorti de la zone et est aux coordonnées : '\(String(describing: location))'")
                        
                        if self.user!.uid != key {
                            let user = usersRef.document(key)
                            user.getDocument { (user, error) in
                                if let user = user, user.exists {
                                    let name = user.get("Username") as! String
                                    let image = URL(string: user.get("Image") as! String)
                                    let stats = user.get("Stats") as! [String: Int]

                                    let user = User(username: name, image: image, id: key, stats: stats)
                                    
                                    if let index = self.users.firstIndex(of: user) {
                                        self.users.remove(at: index)
                                    }
                                    
                                    if self.users.count == 0  {
                                        self.spotCloseUsersLabel.text = "Aucun rider à ce spot"
                                    } else if self.users.count == 1{
                                        self.spotCloseUsersLabel.text = "\(self.users.count) rider est à ce spot"
                                    } else {
                                        self.spotCloseUsersLabel.text = "\(self.users.count) riders sont à ce spot"
                                    }
                                    
                                    self.usersCarousel.reloadData()

                                } else {
                                    
                                    print("User does not exist")
                                }
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
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    spotDistanceLabel.text = "-"
                case .authorizedAlways, .authorizedWhenInUse:
                    let user = locationManager.location!.coordinate
                    let spotLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
                    let distance = round(spotLocation.distance(from: userLocation))
                    
                    // FIXME: Gérer les cas où il serait plus pertinent de s'exprimer en km
                    spotDistanceLabel.text = "\(distance)m"
                @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
        
        spotName.text = name.uppercased()
        
        if users.count == 0  {
            spotCloseUsersLabel.text = "Aucun rider à ce spot"
        } else if users.count == 1{
            spotCloseUsersLabel.text = "\(users.count) rider est à ce spot"
        } else {
            spotCloseUsersLabel.text = "\(users.count) riders sont à ce spot"
        }
        
        spotPicture.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named:"background-out.png"), options: .highPriority, completed: { (image, error, cacheType, url) in
            guard image != nil else {
                return
            }
            
            self.spotPicture.image = self.spotPicture.image?.convertToGrayScale()
            
        })
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

// MARK: - EXTENSIONS

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
        cell.contentView.backgroundColor = UIColor.CrewSade.mainColorLight
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
