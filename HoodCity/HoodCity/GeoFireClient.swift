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
    let firebaseClient = FirebaseClient()
    
    init() {
        self.firebaseDatabaseReference = Database.database().reference().child("events")
        self.geoFire = GeoFire(firebaseRef: firebaseDatabaseReference)
    }

    func newSighting(at location: CLLocation, for event: EventType, with key: String, date: String) {
        geoFire.setLocation(location, forEvent: event.type, withKey: key, date: date)
    }
    
    typealias GeoFireData = (String, CLLocation)
    
    func showEvents(at location: CLLocation, completionHandler: @escaping (GeoFireData?, GeoFireError?) -> Void) {
        let query = geoFire.query(at: location, withRadius: 7)
        
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
    
    func observeExitedKeys(at location: CLLocation, completionHandler: @escaping (String?, GeoFireError?) -> Void) {
        let query = geoFire.query(at: location, withRadius: 7)
        
        query?.observe(.keyExited, with: { (key, location) in
            guard let key = key else {
                completionHandler(nil, GeoFireError.observeExitedKeysFailed)
                
                return
            }
            
            completionHandler(key, nil)
        })
    }
    
    // Remove keys
    
    func remove(_ event: Event, completionHandler: @escaping (GeoFireError?) -> Void) {
        geoFire.removeKey(event.id) { (error) in
            if error != nil {
                completionHandler(GeoFireError.keyWasNotRemoved)
            } else {
                self.firebaseClient.removeEventFrom(userId: event.eventData.userID, eventId: event.id)
                completionHandler(nil)
            }
        }
    }
}

