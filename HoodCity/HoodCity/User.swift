//
//  User.swift
//  HoodCity
//
//  Created by Iván Martínez on 29/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

class User {
    
    static let shared = User()
    
    var name: String?
    var profilePicture: UIImage?
    var email: String?
    
    private init?() {
    }
    
    init(name: String?, email: String?, profilePicture: UIImage?) {
        self.name = name
        self.email = email
        self.profilePicture = profilePicture
    }
    
}
