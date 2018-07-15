//
//  ProfileDetailsVC.swift
//  profiles
//
//  Created by Joshua Gilstrap on 7/13/18.
//  Copyright © 2018 Joshua Gilstrap. All rights reserved.
//

import UIKit
import Firebase

class ProfileDetailsVC: UIViewController {
    var profile: Profile!
    var profileColor = UIColor()
    var hobbiesRef = Database.database().reference()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileAge: UILabel!
    @IBOutlet weak var profileGender: UILabel!
    @IBOutlet weak var profileHobbies: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ref = Database.database().reference(withPath: "profiles/\(profile.id)")
        hobbiesRef = ref.child("hobbies")
        self.title = profile.name
        profileColor = profile.gender == "Male" ? UIColor.babyBlue : UIColor.babyPink
        self.view.backgroundColor = profileColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))

        if let imageData = Data(base64Encoded: profile.profilePicture!) {
            profilePicture.image = UIImage(data: imageData)
        }
        profileName.text = profile.name
        profileAge.text = profile.age
        profileGender.text = profile.gender
        profileHobbies.text = profile.hobbies
        profileHobbies.backgroundColor = profileColor
        profileHobbies.isEditable = false
        profileHobbies.layer.cornerRadius = 8
        profilePicture.layer.cornerRadius = 16
    }
    
    @objc func editTapped() {
        if profileHobbies.isEditable {
            profileHobbies.isEditable = false
            profileHobbies.backgroundColor = profileColor
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            hobbiesRef.setValue(profileHobbies.text)
        } else {
            profileHobbies.isEditable = true
            profileHobbies.backgroundColor = UIColor.white
            self.navigationItem.rightBarButtonItem?.title = "Save"
        }
    }
}
