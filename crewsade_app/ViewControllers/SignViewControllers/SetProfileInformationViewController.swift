//
//  SetProfileInformationViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 08/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit

class SetProfileInformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameInput.setLeftPaddingPoints(10)
        usernameInput.underlined()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapProfilePicture(_ sender: Any) {
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
    
    private func switchToMainStoryboard(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(identifier: "TabBar")
        self.show(mainViewController, sender: nil)
    }
    
    @IBAction func buttonFinishClicked(_ sender: Any) {
        if let username = usernameInput.text, let image = profilePicture.image{
//            FirebaseAuthManager().setProfile(username: username, Image: image){[weak self] (success) in
//                guard let `self` = self else { return }
//                if (success) {
//                    self.switchToMainStoryboard()
//                } else {
//                    print("There was an error.")
//                }
//            }
        }
    }
}
