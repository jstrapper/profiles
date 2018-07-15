//
//  Profile.swift
//  profiles
//
//  Created by Joshua Gilstrap on 7/13/18.
//  Copyright © 2018 Joshua Gilstrap. All rights reserved.
//

import UIKit
import Firebase

struct Profile {
    let ref: DatabaseReference?
    let id: String
    var name: String
    var gender: String?
    var age: String?
    var profilePicture: String?
    var hobbies: String?
    
    init(name: String, gender: String, age: String, profilePicture: String = "", hobbies: String) {
        self.ref = nil
        self.id = String(UInt.random(in: 0 ... UInt.max))
        self.name = name
        self.gender = gender
        self.age = age
        self.profilePicture = profilePicture
        self.hobbies = hobbies
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String:AnyObject],
            let id = snapshot.key as? String,
            let name = value["name"] as? String,
            let gender = value["gender"] as? String,
            let age = value["age"] as? String,
            let profilePicture = value["profilePicture"] as? String,
            let hobbies = value["hobbies"] as? String else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.name = name
        self.gender = gender
        self.age = age
        self.profilePicture = profilePicture
        self.hobbies = hobbies
    }
    
    func toAny() -> Any {
        return [
            "name": name,
            "gender": gender ?? "",
            "age": age ?? "",
            "profilePicture": profilePicture ?? "",
            "hobbies": hobbies ?? ""
        ]
    }
}
