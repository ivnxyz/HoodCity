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
    
    typealias GeoFireData = (String, CLLocation)
    
    func showEvents(at location: CLLocation, completionHandler: @escaping (GeoFireData?, GeoFireError?) -> Void) {
        let query = geoFire.query(at: location, withRadius: 10)
        
        query?.observe(.keyEntered, with: { (key, location) in
            guard let key = key, let location = location else {
                completionHandler(nil, GeoFireError.observeFunctionFailed)
                
                return
            }
            
            let data = GeoFireData(key, location)
            
            completionHandler(data, nil)
        })
    }
    
    // Observe Keys that exited query criteria
    
    func observeExitedKeys(at location: CLLocation, completionHandler: @escaping (GeoFireData?, GeoFireError?) -> Void) {
        let query = geoFire.query(at: location, withRadius: 10)
        
        query?.observe(.keyExited, with: { (key, location) in
            guard let key = key, let location = location else {
                completionHandler(nil, GeoFireError.observeExitedKeysFailed)
                
                return
            }
            
            let data = GeoFireData(key, location)
            
            completionHandler(data, nil)
        })
    }
    
    // Remove keys
    
    func remove(_ key: String, completionHandler: @escaping (GeoFireError?) -> Void) {
        geoFire.removeKey(key) { (error) in
            if error != nil {
                completionHandler(GeoFireError.keyWasNotRemoved)
            } else {
                completionHandler(nil)
            }
        }
    }
}














