//
//  SpotCreationViewController.swift
//  crewsade_app
//
//  Created by Lou Batier on 14/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseStorage
import Geofirestore

class SpotCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

// MARK: - VARIABLES
    
    @IBOutlet weak var spotPicture: UIImageView!
    @IBOutlet weak var separator: UIImageView!
    @IBOutlet weak var spotNameInputLabel: UILabel!
    @IBOutlet weak var spotNameInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
// MARK: - LIFECYCLE & OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupLocationManager()
    }
    
// MARK: - ACTIONS
    
    @IBAction func didTapSpotPicture(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let spotPictureSheet = UIAlertController(title: "Photo du spot", message: "Choisissez une photo", preferredStyle: UIAlertController.Style.actionSheet)
        
        spotPictureSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        spotPictureSheet.addAction(UIAlertAction(title: "Gallerie", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        spotPictureSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(spotPictureSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func submitSpot(_ sender: UIButton) {
        
        let location = locationManager.location!.coordinate
        let spotsRef = db.collection("spots")
        let spotsCol = GeoFirestore(collectionRef: spotsRef)
        let spot = spotsRef.document()
        
        let spotPictureStorageRef = self.storage.reference().child("spots/\(spot.documentID)/spot_picture")
        
        if let name = spotNameInput.text, let image = spotPicture.image {
            
            guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            spotPictureStorageRef.putData(imageData, metadata: metadata){(metadata, error) in
                if (error == nil) {
                    
                    spotPictureStorageRef.downloadURL(completion: {(url,error) in
                        if let url = url{
                            spot.setData([
                                "name" : name,
                                "game" : false,
                                "image" : url.absoluteString
                            ])
                            spotsCol.setLocation(geopoint: GeoPoint(latitude: location.latitude, longitude: location.longitude), forDocumentWithID: spot.documentID) { (error) in
                                if let error = error {
                                    print("Une erreur est survenue : \(error)")
                                } else {
                                    print("Spot \(spot.documentID) enregistré !")
                                }
                            }
                            
                            UserService().updateSpots()
                        }
                    })
                    
                }
                else {
                    print("Erreur upload de l'image")
                }
            }
        }
        
        // TODO: À faire dans un callback pour s'assurer que les informations sont enregistrées ?
        dismiss(animated: true, completion: nil)
    }
    
// MARK: - METHODS
    
    func setup() {
        
        spotNameInputLabel.text = spotNameInputLabel.text?.uppercased()
        
        spotNameInput.underlined()
        spotNameInput.setLeftPaddingPoints(10)
        
        submitButton.layer.cornerRadius = 4
        submitButton.backgroundColor = UIColor.CrewSade.mainColorLight
        submitButton.setTitle(submitButton.titleLabel?.text?.uppercased(), for: .normal)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        spotPicture.image =  image.convertToGrayScale()
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}


// MARK: - EXTENSIONS

extension SpotCreationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ : CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
    }
    
}
