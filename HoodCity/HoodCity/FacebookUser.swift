//
//  FacebookUser.swift
//  HoodCity
//
//  Created by Iván Martínez on 29/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

class FacebookUser {
    static let shared = FacebookUser()
    
    var name = ""
    var profilePicture = UIImage()
    var email = ""
    
    private init() {
        print("Facebook user initialized")
    }
}
