//
//  AddProfileVC.swift
//  profiles
//
//  Created by Joshua Gilstrap on 7/13/18.
//  Copyright © 2018 Joshua Gilstrap. All rights reserved.
//

import UIKit
import Firebase
import CoreGraphics

class AddProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let ref = Database.database().reference(withPath: "profiles")
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileAge: UITextField!
    @IBOutlet weak var profileGender: UISegmentedControl!
    @IBOutlet weak var profileHobbies: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileHobbies.layer.borderWidth = 0.2
        profileHobbies.layer.cornerRadius = 8
        profilePicture.layer.cornerRadius = 16
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profilePicture.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
        print("hey")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let name = self.profileName.text {
            let gender = profileGender.titleForSegment(at: profileGender.selectedSegmentIndex)
            let age = profileAge.text ?? ""
            let hobbies = profileHobbies.text ?? ""
            let str64 = profilePicture.image?.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
            let profile = Profile(name: name, gender: gender!, age: age, profilePicture: str64, hobbies: hobbies)
            let profileRef = self.ref.child(String(profile.id))
            profileRef.setValue(profile.toAny())
            self.dismiss(animated: true)
        } else {
            self.showSimpleAlert(title: "Name Required", message: "Give the new profile a name!", button: "OK")
        }
    }
}
