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

class SpotCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var spotPicture: UIImageView!
    @IBOutlet weak var spotNameInputLabel: UILabel!
    @IBOutlet weak var spotNameInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
    }
    
    // PASSER LE locationManager DANS UN SEGUE ?
    
    func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
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
        
        let newSpot = db.collection("spots").document()
        let spotPictureStorageRef = self.storage.reference().child("spots/\(newSpot.documentID)/spot_picture")
        
        if let name = spotNameInput.text, let image = spotPicture.image {
            
            guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            spotPictureStorageRef.putData(imageData, metadata: metadata){(metadata, error) in
                if (error == nil) {
                    
                    spotPictureStorageRef.downloadURL(completion: {(url,error) in
                        if let url = url{
                            newSpot.setData([
                                "name" : name,
                                "coords" : GeoPoint(latitude: location.latitude, longitude: location.longitude),
                                "game" : false,
                                "image" : url.absoluteString
                            ])
                        }
                    })
                    
                }
                else {
                    print("Erreur upload de l'image")
                }
            }
        }
        
        // A FAIRE DANS UN CALLBACK POUR S'ASSURER QUE LES INFOS SONT ENREGISTRÉES ?
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        spotPicture.image =  image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension SpotCreationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ : CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
    }
}

