//
//  GeoFireClient.swift
//  HoodCity
//
//  Created by Iván Martínez on 11/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GeoFireClient {
    
    let firebaseDatabaseReference: DatabaseReference
    let geoFire: GeoFire
    
    init() {
        self.firebaseDatabaseReference = Database.database().reference()
        self.geoFire = GeoFire(firebaseRef: firebaseDatabaseReference)
    }
    
    func createSighting(for location: CLLocation, with eventID: String) {
        geoFire.setLocation(location, forKey: "\(eventID)")
    }
    
    func getEvents(at location: CLLocation, completionHandler: @escaping (String?, CLLocation?) -> Void) {
        let query = geoFire.query(at: location, withRadius: 10)
        
        query?.observe(.keyEntered, with: { (key, location) in
            guard let key = key, let location = location else {
                completionHandler(nil, nil)
                
                return
            }
            
            completionHandler(key, location)
        })
    }
}
