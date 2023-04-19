//
//  ProfileViewController.swift
//  EventPlanner
//
//  Created by  on 2023-04-02.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var bioTextView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let email = mainDelegate.currentUserEmail
        mainDelegate.readDataFromProfileDatabase()
        
        for profile in mainDelegate.profiles {
            if profile.email == email {
                // Email Found
                let name = profile.name
                profilePictureImageView.image = UIImage(named: profile.pic ?? "default.jpg")
                        nameLabel.text = profile.name
                        emailLabel.text = profile.email
                        bioTextView.text = profile.bio
                break // Exit the loop since we found the profile
            }
        }
        


        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.width / 2
        profilePictureImageView.clipsToBounds = true

    }


}
