//
//  SetUsernameViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 07/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SetUsernameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VOTRE PROFILE"
        
        usernameInput.setLeftPaddingPoints(10)
        profilePicture.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        
        let profilePictureSheet = UIAlertController(title: "Photo de profil", message: "Choisissez une photo", preferredStyle: UIAlertController.Style.actionSheet)
        
        profilePictureSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        profilePictureSheet.addAction(UIAlertAction(title: "Gallerie", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        profilePictureSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(profilePictureSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        profilePicture.image =  image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonClicked(_ sender: Any) {
        if let username = usernameInput.text,let image = profilePicture.image{
            UserService().setProfile(username: username, Image: image){[weak self] (success) in
                guard let `self` = self else { return }
                if (success) {
                    self.switchToMainStoryboard()
                } else {
                    print("Error")
                }
            }
        }
    }
    
    private func switchToMainStoryboard(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
        self.show(mainViewController, sender: nil)
    }
}
