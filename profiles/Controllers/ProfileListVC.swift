//
//  ProfileListVC.swift
//  profiles
//
//  Created by Joshua Gilstrap on 7/13/18.
//  Copyright © 2018 Joshua Gilstrap. All rights reserved.
//

import UIKit
import Firebase

class ProfileListVC: UITableViewController {

    var profiles: [Profile] = []
    var profilesHolder: [Profile] = []
    var filteredProfiles: [Profile] = []
    var filterFlag = 0
    var sortNameFlag = 0
    var sortAgeFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference(withPath: "profiles")
        ref.observe(.value, with: { snapshot in
            var newProfiles: [Profile] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let profile = Profile(snapshot: snapshot) {
                    newProfiles.append(profile)
                }
            }            
            self.profiles = newProfiles.sorted(by: { $0.id < $1.id })
            self.profilesHolder = self.profiles
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ProfileCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProfileListCell else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier)")
        }
        let profile = profiles[indexPath.row]
        
        cell.backgroundColor = profile.gender == "Male" ? .babyBlue : .babyPink
//        cell.profilePicture.image = profile.profilePicture
        cell.profileName.text = profile.name
        if let imageData = Data(base64Encoded: profile.profilePicture!) {
            cell.profilePicture.image = UIImage(data: imageData)
        }
        cell.profilePicture.layer.cornerRadius = 16
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let profile = profiles[indexPath.row]
            profile.ref?.removeValue()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let profileDetailsVC = segue.destination as? ProfileDetailsVC, let indexPath = tableView.indexPathForSelectedRow {
            let selectedProfile = profiles[indexPath.row]
            profileDetailsVC.profile = selectedProfile
        }
    }
    
    @IBAction func clearFiltersTapped(_ sender: Any) {
        profiles = profilesHolder
        filterFlag = 0
        sortNameFlag = 0
        sortAgeFlag = 0
        tableView.reloadData()
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        switch filterFlag {
        case 0:
            profiles = profilesHolder.filter { $0.gender == "Male" }
            tableView.reloadData()
            filterFlag = 1
        case 1:
            profiles = profilesHolder.filter { $0.gender == "Female" }
            tableView.reloadData()
            filterFlag = 2
        case 2:
            profiles = profilesHolder
            tableView.reloadData()
            filterFlag = 0
        default:
            return
        }
    }
    
    @IBAction func sortNameTapped(_ sender: Any) {
        switch sortNameFlag {
        case 0:
            profiles = profiles.sorted(by: { $0.name < $1.name })
            tableView.reloadData()
            sortNameFlag = 1
        case 1:
            profiles = profiles.sorted(by: { $0.name > $1.name })
            tableView.reloadData()
            sortNameFlag = 2
        case 2:
            profiles = profiles.sorted(by: { $0.id < $1.id })
            tableView.reloadData()
            sortNameFlag = 0
        default:
            return
        }
    }
    
    @IBAction func sortAgeTapped(_ sender: Any) {
        switch sortAgeFlag {
        case 0:
            profiles = profiles.sorted(by: { Int($0.age ?? "") ?? 0 < Int($1.age ?? "") ?? 0 })
            tableView.reloadData()
            sortAgeFlag = 1
        case 1:
            profiles = profiles.sorted(by: { Int($0.age ?? "") ?? 0 > Int($1.age ?? "") ?? 0 })
            tableView.reloadData()
            sortAgeFlag = 2
        case 2:
            profiles = profiles.sorted(by: { $0.id < $1.id })
            tableView.reloadData()
            sortAgeFlag = 0
        default:
            return
        }
    }
    
}

