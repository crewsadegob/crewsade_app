//
//  SignUpViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 30/04/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit
import FBSDKCoreKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    let signUpManager = FirebaseAuthManager()
    
    var showPasswordIcon:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameInput.setLeftPaddingPoints(10)
        emailInput.setLeftPaddingPoints(10)
        passwordInput.setLeftPaddingPoints(10)
        
        usernameInput.underlined()
        emailInput.underlined()
        passwordInput.underlined()
        
        
        profilePicture.setRoundedImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    @IBAction func buttonSignUpClicked(_ sender: Any) {
        indicator.startAnimating()
        if let email = emailInput.text,let password = passwordInput.text, let username = usernameInput.text, let image = profilePicture.image{
            signUpManager.createUser(username: username,Image: image,email: email, password: password, view: self) {[weak self] (success) in
                guard let `self` = self else { return }
                if (success) {
                    self.indicator.stopAnimating()
                    self.switchToMainStoryboard()
                } else {
                    self.indicator.stopAnimating()
                    print("Error")
                }
            }
        }
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        if(showPasswordIcon == true) {
            passwordInput.isSecureTextEntry = false
            sender.setBackgroundImage(UIImage(named: "eyeOpen.png"), for: .normal)
        } else {
            passwordInput.isSecureTextEntry = true
            sender.setBackgroundImage(UIImage(named: "eyeClose.png"), for: .normal)
        }
        
        showPasswordIcon = !showPasswordIcon
    }
    
    @IBAction func didTapProfilePicture(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let profilePictureSheet = UIAlertController(title: "Photo de profil", message: "Choisissez une photo", preferredStyle: UIAlertController.Style.actionSheet)
        
        profilePictureSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        profilePictureSheet.addAction(UIAlertAction(title: "Galerie", style: .default, handler: {(action:UIAlertAction) in
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
}


