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
    
    private init?() {
    }
    
    init(name: String?, profilePicture: UIImage?) {
        self.name = name
        self.profilePicture = profilePicture
    }
    
}
