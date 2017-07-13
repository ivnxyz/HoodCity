//
//  FirebaseClient.swift
//  HoodCity
//
//  Created by Iván Martínez on 12/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseClient {
    let userReference = Database.database().reference().child("users/ivnxyz")
    
    func addEvent(withID id: String) {
        userReference.updateChildValues(["\(id)": true])
    }
}
