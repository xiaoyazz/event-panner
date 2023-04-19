//
//  Profile.swift
//  EventPlanner
//
//  Created by  on 2023-04-19.
//

import UIKit

class Profile: NSObject {
    var id: Int?
    var pic: String?
    var name: String?
    var email: String?
    var bio: String?

    func initWithData(id: Int, pic: String, name: String, email: String, bio: String) {
        self.id = id
        self.pic = pic
        self.name = name
        self.email = email
        self.bio = bio
    }
}
